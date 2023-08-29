from json import loads

def get_db_connection_config()->dict:
    with open('db/db_config.json') as f:
        data= f.read()
    return loads(data)

def read_sql(file_name:str, encoding='utf-8')->str:
    with open(f'db/sql/{file_name}.sql','r',encoding=encoding) as f:
        sql=f.read()
    return sql