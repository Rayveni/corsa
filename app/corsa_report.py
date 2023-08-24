from db import db_manager, get_db_connection_config, read_sql

source_sheet = 'AENT'


class corsa_report:
    report_id: str
    script_version: str = '0.1'
    file_name: str
    user: str
    load_mode: str
    db_conn_config: dict
    load_id: int
    error_log: list
    auto_extrapolation: bool

    def __init__(self, report_id, file_name, user, load_mode, auto_extrapolation) -> None:
        self.report_id = report_id
        self.file_name = file_name
        self.user = user
        self.load_mode = load_mode
        self.db_conn_config = get_db_connection_config()
        self._AreIncorrRateNames: bool = False
        self.error_log = []
        self.auto_extrapolation = auto_extrapolation

    async def upload_data(self, workbook):
        await self.add_log_corsa(status='В процессе загрузки или сбой')
        if self.load_mode in ('Detailed&Aggregated', 'Detailed&Aggregated&Buddah'):
            await self.perform_aents_detailed()

        else:
            if source_sheet not in workbook.sheetnames:
                self.error_log.append(
                    [f'Отсутсвует лист {source_sheet}в книге'])
                return None
            ws = workbook[source_sheet]
            await self.perform_aents_common(ws)
            await self.recalc_simple()

        db_conn = db_manager(**self.db_conn_config)
        await db_conn.transaction(read_sql('endUploadCorrs_Oracle').format(user=self.user))
        await self.CheckCCorsOracle()
        await self.InitCorsaStep2()  # заглушка
        await self.AutoCorrectionsOracle()  # заглушка
        await self.UpdLogOracle("Ок")

        """      
        обновляем excel ,игнорим
            If BaseMode = "Detailed&Aggregated" Or BaseMode = "Detailed&Aggregated&Buddah" Then
                '''
            Else
                Call CorsaFinals(Final_mess)
        """

    """       


    If GoOnStatus = 1 Then
        CmdTxt = "UPDATE msfo.mmi_detailed_status st SET st.status='Готово', date_from = (select sessiontime from msfo.CORSA_log where load_id=" & LoadIDCorsa & ") " _
        & " where st.status='Не готово' and id_period_to = " & DateToID
        Call RunOraCmd(CmdTxt)
    End If

    Call UpdLogOracle("Ок") await self.UpdLogOracle("Ок")


        """

    async def InitCorsaStep2(self):
        # похоже никаких нужных таблиц не заполняем
        pass

    async def AutoCorrectionsOracle(self):
        # похоже никаких нужных таблиц не заполняем
        pass

    async def CheckCCorsOracle(self):
        rs, _err_flg = {}, 0

        _errors = {1: 'Неуникальные коды строк',
                   2: 'Небалансирующие корректировки:',
                   3: 'Неокругленные суммы в строках',
                   4: 'Строки той же корректировки уже загружены другим пользователем:',
                   5: 'Пустые или недопустимые комментарии по упрощению в строках:'}
        for i in range(1, 6):
            db_conn = db_manager(**self.db_conn_config)
            data = await db_conn.run_sql_query(read_sql(f'rs{i}_CheckCCorsOracle'), query_args=[self.user], execute=False)
            if data != []:
                _err_flg += 1
                self.error_log.append([f'rs{i}', _errors[i], data])
            rs[f'rs{i}'] = data

        if _err_flg > 0:
            await self.UpdLogOracle("Некорректные проводки")
            await self.OracleClearCurrents()

    async def OracleClearCurrents(self):
        db_conn = db_manager(**self.db_conn_config)
        await db_conn.run_sql_query(read_sql('OracleClearCurrents'), query_args=[self.user], execute=True)

    async def InitCorsaStep2(self):
        pass

    async def AutoCorrectionsOracle(self):
        pass

    async def recalc_simple(self):
        db_conn = db_manager(**self.db_conn_config)
        _data = await db_conn.run_sql_query(read_sql('extrapolation_count'),
                                            query_args=[self.user],
                                            execute=False)
        NumExtr = _data[0]['_cnt']
        if NumExtr == 0:
            pass
        else:
            if self.auto_extrapolation:
                _extrapolation_mode = 'Экстраполяция автоматическая'
            else:
                _extrapolation_mode = 'Экстраполяция ручная'

            db_conn = db_manager(**self.db_conn_config)
            _data = await db_conn.run_sql_query(read_sql('extrapolation_mode'),
                                                query_args=[
                                                    _extrapolation_mode, 'Экстраполяция', self.user, self.load_id],
                                                execute=False)
            # заглушка для диалогового окна  CORSA_RECALCSIMPLE
        db_conn = db_manager(**self.db_conn_config)
        sql = read_sql('CORSA_RECALCSIMPLE').format(user=self.user)
        await db_conn.transaction(sql)

    async def add_log_corsa(self, status: str = '') -> None:
        load_comment = f'{self.load_mode}. Версия №{self.script_version}.2 от 12.04.2023'
        db_conn = db_manager(**self.db_conn_config)
        query_params = [self.report_id,
                        self.user,
                        self.file_name,
                        self.user, self.report_id,
                        status]

        data = await db_conn.run_sql_query(read_sql('add_log_corsa'), query_args=query_params, execute=False)
        self.load_id = data[0]['load_id']

    async def perform_aents_detailed(self):
        """ вставка в таблицы удалена
        CORSA_DA_current,CORSA_DA_REPLACE,CORSA_SEGMENTS_CURRENT,CORSA_seg_to_segcur
        """
        db_conn = db_manager(**self.db_conn_config)
        sql = read_sql('perform_aents_detailed').format(
            reportid=self.report_id, load_id=self.load_id, UserName=self.user)
        await db_conn.transaction(sql)

    async def perform_aents_common(self, ws):
        start_row = 6
        NonNumericRows, IncorrestELCs = False, False
        header = [str(ws.cell(row=start_row, column=i).value).strip()
                  for i in range(1, ws.max_column+1)]

        def get_col_index(x): return header.index(x)+1 if x in header else 0
        IAS5Col = get_col_index('Статья')
        AmountCol = get_col_index('Сумма')
        EntryLineCodeCol = get_col_index('Код строки')
        CorrNameCol = get_col_index('Комментарий')
        CommentCol = get_col_index('Статья')
        PrelimCol = get_col_index('Предварительно')
        CommSimplCol = get_col_index('COMM_SIMPL')
        Col_Ratio = get_col_index('SEG_Ratio')

        def isNone(x): return " " if x is None else str(x)
        stop_flg = False
        for iRow in range(start_row+1, ws.max_row+1):
            EntryLineCodeCol_value = ws.cell(
                row=iRow, column=EntryLineCodeCol).value
            if EntryLineCodeCol_value is not None:
                stop_flg = True
            # реализация vba To Cells(1000000, EntryLineCodeCol).End(xlUp).Row
            if EntryLineCodeCol_value is None and stop_flg:
                break
            IAS5 = isNone(ws.cell(row=iRow, column=IAS5Col).value).replace(
                " ", "").replace("'", "").strip()
            EntryLineCode = isNone(EntryLineCodeCol_value).strip()
            if len(IAS5) > 0 and len(EntryLineCode) > 0:
                # строка для загрузки
                if self.IsEntryLineCode(EntryLineCode):
                    try:
                        _val = ws.cell(row=iRow, column=AmountCol).value

                    except:
                        _val = None
                    if _val is None:
                        ValueOk = False
                    elif type(ws.cell(row=iRow, column=AmountCol).value) in (int, float):
                        ValueOk = True
                    else:
                        ValueOk = False

                    if ValueOk:
                        if CommentCol > 0:
                            Comment = isNone(ws.cell(row=iRow, column=CommentCol).value).replace(
                                "'", "''")[:300]
                        else:
                            Comment = "_"
                        Amount = round(
                            ws.cell(row=iRow, column=AmountCol).value, 2)
                        if PrelimCol > 0:
                            if isNone(ws.cell(row=iRow, column=PrelimCol).value).strip() != "":
                                Prelim = "Y"
                            else:
                                Prelim = "N"
                        else:
                            Prelim = "N"
                        if CommSimplCol > 0:
                            Comm_Simpl = self.CommSimplFunc(
                                isNone(ws.cell(row=iRow, column=CommSimplCol).value))
                        if CorrNameCol > 0:
                            CorrName = isNone(
                                ws.cell(row=iRow, column=CorrNameCol).value).strip()
                        else:
                            CorrName = ""
                        Sum_SegVL = 0
                        if Col_Ratio > 0:
                            #self.UploadLineSegAll(iRow,ws.cell(row=iRow, column=Col_Ratio).value.upper())
                            pass
                        await self.UploadLineOracle_oo4o(IAS5, Comment, Amount, Prelim, EntryLineCode, CorrName, 0, iRow, '0', Comm_Simpl)
                    else:
                        NonNumericRows, IncorrestELCs = await self.AddErrLine("NonNumericRows", iRow, NonNumericRows, IncorrestELCs)
                else:

                    NonNumericRows, IncorrestELCs = await self.AddErrLine("IncorrestELCs", iRow, NonNumericRows, IncorrestELCs)
            else:
                if CommentCol > 0:
                    Comment = isNone(
                        ws.cell(row=iRow, column=CommentCol).value)[:300]
                else:
                    Comment = "_"
                # Amount = ws.cell(row=iRow, column=IAS5Col + 1).fill.start_color.index
                Amount = -999999
                if CorrNameCol > 0:
                    CorrName = isNone(
                        ws.cell(row=iRow, column=CorrNameCol).value).strip()
                else:
                    CorrName = ""

                ORE_Sh = 2 if self.user in ("FEDOROVA_VV", "GOLSHEVA_VA", "SHAMALO_SA",
                                            "DOLGOVA_EM", "EKIMOVA_MA", "BORDULEVA", "MAKIEVSKAYA_IV") else 1

                __IAS5Col = ws.cell(row=iRow, column=IAS5Col + ORE_Sh)

                _bold = '1' if __IAS5Col.font.b else '0'
                _italic = '1' if __IAS5Col.font.i else '0'
                __color = __IAS5Col.font.color
                try:
                    __color = __color.rbg
                except:
                    __color = None
                await self.UploadLineOracle_oo4o(_bold + _italic + isNone(__IAS5Col.value)[:253], Comment, Amount, "", "_" + EntryLineCode, CorrName, 2, iRow, '16711680' if __color is None else __color, __color)
        await self.oo4o_Finish()

    async def oo4o_Finish(self):
        db_conn = db_manager(**self.db_conn_config)
        data = await db_conn.run_sql_query(read_sql('oo4o_Finish'), execute=True)

    async def AddErrLine(self, ErrType: str, row_num: int, NonNumericRows: bool, IncorrestELCs: bool) -> tuple:
        await self.UpdLogOracle("Нечисловые значения в столбце сумм/некорректные коды строк")

        if ErrType == "IncorrestELCs":
            IncorrestELCs = True
        if ErrType == "NonNumericRows":
            NonNumericRows = True
        self.error_log.append([ErrType, row_num])
        return NonNumericRows, IncorrestELCs

    async def UpdLogOracle(self, Status: str) -> tuple:
        db_conn = db_manager(**self.db_conn_config)
        query_params = [Status, self.load_id]

        data = await db_conn.run_sql_query(read_sql('UpdLogOracle'), query_args=query_params, execute=True)

    def IsEntryLineCode(self, inp: str) -> bool:
        inp = str(inp).upper()
        if len(inp) >= 3:
            i_elc = len(inp)
            if inp.find("N") > -1 and inp[-1].isnumeric():
                while i_elc > 2:
                    i_elc = i_elc - 1
                    Symb = inp[i_elc-1]
                    if Symb == "N":
                        return True
                    elif Symb.isnumeric() or Symb == "_":
                        pass
                    else:
                        return False

    def CommSimplFunc(self, inp: str) -> str:
        inp = str(inp).strip().upper()
        if inp[:6] == 'ЭКСТРА' and 'РУЧН' in inp:
            res = 'Экстраполяция ручная'
        elif inp[:6] == 'ЭКСТРА' and 'РУЧН' in inp:
            res = 'Экстраполяция автоматическая'
        elif inp[:6] == 'ЭКСТРА':
            res = 'Экстраполяция'
        elif inp[:3] == 'БЕЗ' and 'ИЗМ' in inp:
            res = 'Без изменений'
        elif inp[:3] == 'НОВ' and 'РАСЧ' in inp:
            res = 'Новый расчет'
        else:
            res = 'Недопустимое значение'
        return res

    def UploadLineSegAll(self, NRow: int, Ratio_name: str) -> str:
        # запроняем msfo.CORSA_SEGMENTS_CURRENT  таблица не нужна
        pass

    async def UploadLineOracle_oo4o(self, IAS5: str, Comment: str, Amount: int, Prelim: str, EntryLineCode: str, CorrName: str, Auto: int, VL_Seg: int, sysid: int, Comm_Simpl: str = ''):
        db_conn = db_manager(**self.db_conn_config)
        if Prelim == "Y":
            Prelim = "Preliminary"
        else:
            Prelim = "Final"

        entrycode = EntryLineCode.upper()
        pos_EntryLineCode = entrycode.find('N')
        if pos_EntryLineCode == -1:
            entrycode = None
        else:
            entrycode = entrycode[:pos_EntryLineCode]

        query_params = [self.load_id,  # load_id,
                        self.report_id,  # reportid,
                        CorrName,  # corrname_l,
                        IAS5,  # ias5_l,
                        Amount,  # vl,
                        EntryLineCode,  # entrylinecode,
                        self.user,  # username,
                        None,  # loaddate,,
                        None,  # loadtime,
                        sysid,  # sysid,
                        None,  # sessiontime,
                        Prelim,  # prelim,
                        Comment,  # corr_comment,
                        None,  # changetime,
                        Auto,  # type_auto,
                        0,  # addednull,
                        entrycode,  # entrycode,
                        VL_Seg,  # vl_seg)
                        Comm_Simpl]

        data = await db_conn.run_sql_query(read_sql('UploadLineOracle_oo4o'), query_args=query_params, execute=True)