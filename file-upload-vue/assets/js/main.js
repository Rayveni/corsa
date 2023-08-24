axios.defaults.headers.common['Authorization'] = 'Bearer ' + localStorage.getItem('userToken');

// const firstDayInPreviousMonth = function (d) {
//     return new Date(d.getFullYear(), d.getMonth() - 1, 1);
// };
const lastDayInPreviousMonth = function (d) {
    return new Date(d.getFullYear(), d.getMonth(), 0);
}

const formatDate = function(d) {
    var str = '';
    str = d.getFullYear() + '-' +
        ('00' + (d.getMonth()+1)).slice(-2) + '-' +
        ('00' + d.getDate()).slice(-2);
    return str;
}

const validateAddFormQuantity = function(rule, value, callback) {
    if (value != undefined && value !== '') {
        if (value < 0) {
            callback(new Error('Quantity не может быть меньше 0'));
        }
    }
    callback();
};

const validateDeleteFormValidTo = function(rule, value, callback) {
    valueDate = new Date(value);

    d = new Date();
    currentMonthLastDay = new Date(d.getFullYear(), d.getMonth() + 1, 0);
    console.log(currentMonthLastDay);
    if (valueDate < currentMonthLastDay) {
        callback(new Error('Valid to не может быть раньше, чем дата текущей отчетности'));
    }
    callback();
};

const validateAddFormInitialAmount = function(rule, value, callback) {
    if (value != undefined && value !== '') {
        if (value < 0) {
            callback(new Error('Initial amount не может быть меньше 0'));
        }
    }
    callback();
};

ELEMENT.locale(ELEMENT.lang.ruRU)

new Vue({
    el: '#app',
	data: {
        backendUrl: "http://127.0.0.1:8000",
        // backendUrl: 'https://0a6a-178-89-28-25.ap.ngrok.io',
        elementDeleteIsDisabledBtn: true,
        elementGetInfoIsDisabledBtn: true,
        loadingTable: false,
        addNewElementDialog: {
            dialogIsVisible: false,
            validFromIsDisabled: true,
            step: 1,
            balanceNums: [],
            addForm: {
                model: {
                    section: '',
                    reclassName: '',
                    validFrom: formatDate(lastDayInPreviousMonth(new Date())),
                    validTo: formatDate(new Date('01/01/5555')),
                    account: '',
                    branch: '',
                    isin: '',
                    folder: '',
                    ras2: '',
                    idDeal: '',
                    quantity: 0,
                    reclassDate: '',
                    offerDate: '',
                    initialAmount: 0,
                    useScheduleFlag: false,
                },
                rules: {
                    section: [
                        { required: true, message: 'Необходимо ввести section', trigger: 'blur' },
                        { min: 1, max: 2000, message: 'Длина введенного текста должна быть от 1 to 2 000 символов', trigger: 'blur' }
                    ],
                    reclassName: [
                        { required: true, message: 'Необходимо ввести reclass name', trigger: 'blur' },
                        { min: 1, max: 2000, message: 'Длина введенного текста должна быть от 1 to 2 000 символов', trigger: 'blur' }
                    ],
                    validFrom: [
                        { required: true, message: 'Необходимо внести valid from', trigger: 'blur' },
                    ],
                    validTo: [
                        { required: true, message: 'Необходимо внести valid to', trigger: 'blur' },
                    ],
                    account: [
                        { min: 1, max: 30, message: 'Длина введенного текста должна быть от 1 to 30 символов', trigger: 'blur' }
                    ],
                    branch: [
                        { min: 1, max: 256, message: 'Длина введенного текста должна быть от 1 to 256 символов', trigger: 'blur' }
                    ],
                    isin: [
                        { required: true, message: 'Необходимо ввести isin', trigger: 'blur' },
                        { min: 1, max: 15, message: 'Длина введенного текста должна быть от 1 to 15 символов', trigger: 'blur' }
                    ],
                    folder: [
                        { min: 1, max: 256, message: 'Длина введенного текста должна быть от 1 to 256 символов', trigger: 'blur' }
                    ],
                    ras2: [
                        { required: true, message: 'Необходимо ввести ras2', trigger: 'blur' },
                        { min: 1, max: 5, message: 'Длина введенного текста должна быть от 1 to 5 символов', trigger: 'blur' }
                    ],
                    idDeal: [
                        { min: 1, max: 256, message: 'Длина введенного текста должна быть от 1 to 256 символов', trigger: 'blur' }
                    ],
                    quantity: [
                        { validator: validateAddFormQuantity, trigger: 'change' }
                    ],
                    initialAmount: [
                        { validator: validateAddFormInitialAmount, trigger: 'change' }
                    ]
                }
            },
            actionJournalForm: {
                model: {
                    reason: '',
                },
                rules: {
                    reason: [
                        { required: true, message: 'Необходимо ввести reason', trigger: 'blur' },
                        { min: 1, max: 2000, message: 'Длина введенного текста должна быть от 1 to 2 000 символов', trigger: 'blur' }
                    ]
                }
            }
        },
        deleteElementDialog: {
            dialogIsVisible: false,
            step: 1,
            deleteForm: {
                model: {
                    id: null,                    
                    validTo: '',
                },
                rules: {
                    validTo: [
                        { required: true, message: 'Необходимо внести valid to', trigger: 'blur' },
                        { validator: validateDeleteFormValidTo, trigger: 'change' }
                    ]
                }
            },
            actionJournalForm: {
                model: {
                    reason: '',
                },
                rules: {
                    reason: [
                        { required: true, message: 'Необходимо внести reason', trigger: 'blur' },
                        { min: 1, max: 2000, message: 'Длина введенного текста должна быть от 1 to 2 000 символов', trigger: 'blur' }
                    ]
                }
            }
        },
        infoElementDialog: {
            dialogIsVisible: false,
            actions: []
        },
        elements: {
            currentRowElementId: null,
            currentPage: 1,
            pageSize: 10,
            total: 0,
            list: []
        }
    },
    methods: {
        submitAddFormStep1: function() {
            formName = 'addForm';
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    this.addNewElementDialog.step = 2;
                } else {
                    return false;
                }
            });            
        },
        submitAddFormStep2: function() {
            formName = 'addFormActionJournal';
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    console.log(this.addNewElementDialog);

                    var postData = {
                        "section": this.addNewElementDialog.addForm.model.section,
                        "reclass_name": this.addNewElementDialog.addForm.model.reclassName,
                        "valid_from": this.addNewElementDialog.addForm.model.validFrom,
                        "valid_to": this.addNewElementDialog.addForm.model.validTo,
                        "isin": this.addNewElementDialog.addForm.model.isin,
                        "ras2": this.addNewElementDialog.addForm.model.ras2,
                        "use_schedule_flag": this.addNewElementDialog.addForm.model.useScheduleFlag
                    };

                    if (this.addNewElementDialog.addForm.model.account !== '') {
                        postData['account'] = this.addNewElementDialog.addForm.model.account;
                    }

                    if (this.addNewElementDialog.addForm.model.branch !== 'branch') {
                        postData['branch'] = this.addNewElementDialog.addForm.model.branch;
                    }

                    if (this.addNewElementDialog.addForm.model.folder !== 'folder') {
                        postData['folder'] = this.addNewElementDialog.addForm.model.folder;
                    }

                    if (this.addNewElementDialog.addForm.model.id_deal !== 'id_deal') {
                        postData['id_deal'] = this.addNewElementDialog.addForm.model.idDeal;
                    }

                    if (this.addNewElementDialog.addForm.model.quantity !== '') {
                        postData['quantity'] = this.addNewElementDialog.addForm.model.quantity;
                    }

                    if (this.addNewElementDialog.addForm.model.reclassDate !== '') {
                        postData['reclass_date'] = this.addNewElementDialog.addForm.model.reclassDate;
                    }

                    if (this.addNewElementDialog.addForm.model.offerDate !== '') {
                        postData['offer_date'] = this.addNewElementDialog.addForm.model.offerDate;
                    }

                    if (this.addNewElementDialog.addForm.model.initialAmount !== '') {
                        postData['initial_amount'] = this.addNewElementDialog.addForm.model.initialAmount;
                    }

                    axios({
                        method: 'post',
                        url: this.backendUrl + '/reclassification/',
                        data: postData
                    }).then((response) => {
                        console.log(response);
                        
                        let reclassification = response.data;

                        axios({
                            method: 'post',
                            url: this.backendUrl + '/act_journal/',
                            data: {
                                user_name: localStorage.getItem('userName'),
                                reason_wrk: this.addNewElementDialog.actionJournalForm.model.reason,
                                action_type: 1,
                                reclassification_id: reclassification.id                          
                            }
                        }).then((response) => {
                            console.log(response);
                            
                            this.elements.list.unshift({
                                id: reclassification.id,
                                section: reclassification.section,
                                reclassName: reclassification.reclass_name,
                                validFrom: reclassification.valid_from,
                                validTo: reclassification.valid_to,
                                account: reclassification.account,
                                branch: reclassification.branch,
                                isin: reclassification.isin,
                                folder: reclassification.folder,
                                ras2: reclassification.ras2,
                                idDeal: reclassification.id_deal,
                                quantity: reclassification.quantity,
                                reclassDate: reclassification.reclass_date,
                                offerDate: reclassification.offer_date,
                                initialAmount: reclassification.initial_amount,
                                useScheduleFlag: reclassification.use_schedule_flag,
                            });

                            this.$notify({
                                title: 'Добавлено',
                                message: 'Новый элемент успешно добавлен',
                                type: 'success'
                            });

                            this.addNewElementDialog.dialogIsVisible = false;
                            this.resetAddForms();
                        }, (error) => {
                            error = error.toJSON();
                            console.log(error);

                            if (error.message == 'Request failed with status code 401') {
                                window.location.replace('/login.html');
                            }

                            this.addNewElementDialog.dialogIsVisible = false;
                            this.resetAddForms();
                        });

                    }, (error) => {
                        error = error.toJSON();
                        console.log(error);

                        if (error.message == 'Request failed with status code 401') {
                            window.location.replace('/login.html');
                        }

                        this.addNewElementDialog.dialogIsVisible = false;
                        this.resetAddForms();
                    });
                } else {
                    return false;
                }
            });
        },
        resetAddForms: function() {
            this.$refs['addForm'].resetFields();
            this.$refs['addFormActionJournal'].resetFields();
            this.addNewElementDialog.step = 1;

            this.addNewElementDialog.addForm.model.validFrom = formatDate(lastDayInPreviousMonth(new Date()));
            this.addNewElementDialog.addForm.model.validTo = formatDate(new Date('01/01/5555'));
        },
        elementsCurrentPageOnChange: function(val) {
            this.elements.currentPage = val;
            this.getElements();
        },
        elementsCurrentRowElementIdOnChange: function(val) {
            if (val !== null) {
                this.elements.currentRowElementId = val.id;
                this.elementDeleteIsDisabledBtn = false;
                this.elementGetInfoIsDisabledBtn = false;
            }
        },
        initElementDeleteDialog: function() {
            this.deleteElementDialog.deleteForm.model.id = this.elements.currentRowElementId; 
            this.deleteElementDialog.dialogIsVisible = true;
        },
        submitDeleteFormStep1: function() {
            formName = 'deleteForm';
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    this.deleteElementDialog.step = 2;
                } else {
                    return false;
                }
            });            
        },
        submitDeleteFormStep2: function() {
            formName = 'deleteFormActionJournal';
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    axios({
                        method: 'put',
                        url: this.backendUrl + '/reclassification/' + this.deleteElementDialog.deleteForm.model.id + '/update-valid-to/',
                        data: {
                            valid_to: this.deleteElementDialog.deleteForm.model.validTo
                        }
                    }).then((response) => {
                        console.log(response);
                        
                        axios({
                            method: 'post',
                            url: this.backendUrl + '/act_journal/',
                            data: {
                                user_name: localStorage.getItem('userName'),
                                reason_wrk: this.deleteElementDialog.actionJournalForm.model.reason,
                                action_type: 2,
                                reclassification_id: this.deleteElementDialog.deleteForm.model.id                        
                            }
                        }).then((response) => {
                            console.log(response);
                            
                            this.$notify({
                                title: 'Исключено',
                                message: 'Элемент успешно исключен',
                                type: 'success'
                            });

                            for (let i = 0; i < this.elements.list.length; i++) {
                                if (this.elements.list[i].id == this.deleteElementDialog.deleteForm.model.id) {
                                    this.elements.list[i].validTo = this.deleteElementDialog.deleteForm.model.validTo;
                                    break;
                                }
                            }
    
                            this.deleteElementDialog.dialogIsVisible = false;
                            this.resetDeleteForms();
                        }, (error) => {
                            error = error.toJSON();
                            console.log(error);

                            if (error.message == 'Request failed with status code 401') {
                                window.location.replace('/login.html');
                            }
    
                            this.deleteElementDialog.dialogIsVisible = false;
                            this.resetDeleteForms();
                        });
                    
                    }, (error) => {
                        error = error.toJSON();
                        console.log(error);

                        if (error.message == 'Request failed with status code 401') {
                            window.location.replace('/login.html');
                        }
                    
                        this.deleteElementDialog.dialogIsVisible = false;
                        this.resetDeleteForms();
                    });
                } else {
                    return false;
                }
            });
        },
        resetDeleteForms: function() {
            this.$refs['deleteForm'].resetFields();
            this.$refs['deleteFormActionJournal'].resetFields();
            this.deleteElementDialog.step = 1;
            
            this.deleteElementDialog.deleteForm.model.id = null;
        },
        initElementInfoDialog: function() {
            this.loadingTable = true;

            this.infoElementDialog.actions = [];

            axios({
                method: 'get',
                url: this.backendUrl + '/reclassification/' + this.elements.currentRowElementId + '/actions/',
                body: {}
            }).then((response) => {
                console.log(response);

                for (let k = 0; k < response.data.length; k++) {
                    this.infoElementDialog.actions.push({
                        userName: response.data[k].user_name,
                        date: response.data[k].date_wrk,
                        reason: response.data[k].reason_wrk,
                        type: (response.data[k].action_type == 1) ? 'добавление' : 'исключение'
                    });
                };

                this.infoElementDialog.dialogIsVisible = true;
                this.loadingTable = false;
            }, (error) => {
                error = error.toJSON();
                console.log(error);

                if (error.message == 'Request failed with status code 401') {
                    window.location.replace('/login.html');
                }
                this.loadingTable = false;
            });            
        },
        getElements: function() {
            this.loadingTable = true;
            
            const skip = this.elements.pageSize * (this.elements.currentPage - 1);
            const limit = this.elements.pageSize;
            
            axios({
                    method: 'get',
                    url: this.backendUrl + '/reclassifications/' + skip + '/' + limit + '/',
                    body: {}
                }).then((response) => {
                    console.log(response);
                    this.elements.total = response.data.total;

                    this.elements.list = [];
                    for (let i = 0; i < response.data.list.length; i++) {
                        this.elements.list.push({
                            id: response.data.list[i].id,
                            section: response.data.list[i].section,
                            reclassName: response.data.list[i].reclass_name,
                            validFrom: response.data.list[i].valid_from,
                            validTo: response.data.list[i].valid_to,
                            account: response.data.list[i].account,
                            branch: response.data.list[i].branch,
                            isin: response.data.list[i].isin,
                            folder: response.data.list[i].folder,
                            ras2: response.data.list[i].ras2,
                            idDeal: response.data.list[i].id_deal,
                            quantity: response.data.list[i].quantity,
                            reclassDate: response.data.list[i].reclass_date,
                            offerDate: response.data.list[i].offer_date,
                            initialAmount: response.data.list[i].initial_amount,
                            useScheduleFlag: response.data.list[i].use_schedule_flag, 
                        });
                    }
                    this.loadingTable = false;
                }, (error) => {
                    error = error.toJSON();
                    console.log(error);

                    if (error.message == 'Request failed with status code 401') {
                        window.location.replace('/login.html');
                    }
                    this.loadingTable = false;
                });
        },
        getBalanceNums: function() {
            this.loadingTable = true;
                        
            axios({
                    method: 'get',
                    url: this.backendUrl + '/balance_nums/',
                    body: {}
                }).then((response) => {
                    console.log(response);
                    this.addNewElementDialog.balanceNums = [];
                    for (let i = 0; i < response.data.data.length; i++) {
                        this.addNewElementDialog.balanceNums.push(response.data.data[i].BACNT_BALANCE_NUM);
                    }
                    this.loadingTable = false;
                }, (error) => {
                    error = error.toJSON();
                    console.log(error);

                    if (error.message == 'Request failed with status code 401') {
                        window.location.replace('/login.html');
                    }
                    this.loadingTable = false;
                });
        },
        setUserRules: function() {
            this.loadingTable = true;
                        
            axios({
                method: 'get',
                url: this.backendUrl + '/user/rules/',
                body: {},
            }).then((response) => {
                console.log(response);

                for (let i = 0; i < response.data.length; i++) {
                    if (response.data[i].valid_from_rule == 1) {
                        this.addNewElementDialog.validFromIsDisabled = false;
                    }
                }
                this.loadingTable = false;
            }, (error) => {
                error = error.toJSON();
                console.log(error);

                if (error.message == 'Request failed with status code 401') {
                    window.location.replace('/login.html');
                }

                this.loadingTable = false;
            });
        },
        logout: function() {
            axios({
                method: 'post',
                url: this.backendUrl + '/logout/',
                body: {},
            }).then((response) => {
                if (response.data.result == 'success') {
                    window.location.replace('/login.html');
                }
            }, (error) => {
                error = error.toJSON();
                console.log(error);

                if (error.message == 'Request failed with status code 401') {
                    window.location.replace('/login.html');
                }

                this.loadingTable = false;
            });
        }
    },
    mounted: function() {
        this.getElements();
        this.setUserRules();
        this.getBalanceNums();
    }
});

