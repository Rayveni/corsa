from fastapi import FastAPI , File, UploadFile,Form
from fastapi.requests import Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from openpyxl import load_workbook
from io import BytesIO
from pydantic import BaseModel
from corsa_report import corsa_report
import sys
import traceback
import json

app = FastAPI()
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ReportParams(BaseModel):
    user: str
    report: str
    load_mode: str
    auto_extrapolation: bool    

    
@app.get("/")
def external_url(request:Request):
    return  str(request.url)

@app.post("/upload")
async def upload( report_params:str = Form(...),file: UploadFile = File(...)):
    error_log,html_next_line=[],' \r\n'

    try:
        _report_params=ReportParams.parse_raw(report_params)
        report_params=json.loads(report_params)
        file_in_memory =await  file.read()
        wb = load_workbook(filename=BytesIO(file_in_memory))

        cr=corsa_report(report_id=str(report_params['report']),
                        file_name=file.filename,
                        user=_report_params.user,
                        load_mode=_report_params.load_mode,
                        auto_extrapolation=_report_params.auto_extrapolation)
        await cr.upload_data(wb)
        error_log=cr.error_log
        
    except Exception:
        ex_type, ex_value, ex_traceback = sys.exc_info()
        trace_back = traceback.extract_tb(ex_traceback)
        stack_trace = [f'{html_next_line}stack_trace']

        for trace in trace_back:
            stack_trace.append(f"File : {trace[0]} , Line :{trace[1]}, Func.Name : {trace[2]}, Message :{trace[3]}")
        stack_trace=html_next_line.join(stack_trace)
        return JSONResponse ({"message": f"{str(ex_value)}{stack_trace}",'status':False})
    finally:
        file.file.close()
    
    if error_log!=[]:
        _message,_status=error_log,False
    else:      
        _message,_status=f"Successfully uploaded {file.filename}",True
    return JSONResponse ({"message": _message,"status":_status})