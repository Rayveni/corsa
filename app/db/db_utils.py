from json import loads

def get_db_connection_config()->dict:
    with open('db/db_config.json') as f:
        data= f.read()
    return loads(data)

def read_sql(file_name:str)->str:
    with open(f'db/sql/{file_name}.sql','r') as f:
        sql=f.read()
    return sql