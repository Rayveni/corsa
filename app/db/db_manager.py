from asyncpg import connect as db_connect

class db_manager:
    
    def __init__(self,user:str,password:str,database:str,host:str,port:int)->None:
        self.conn=db_connect(user=user,password=password,database=database,host=host,port=port)
        
    async def run_sql_query(self,sql:str,query_args:list=[],execute:bool=False):
        connection=await self.conn
        if execute:
            res=await connection.execute(sql,*query_args)
        else:
            res=await connection.fetch(sql,*query_args)
            res=[dict(row) for row in res]
        await connection.close()
        return res
    
    async def transaction(self,sql:str):
        connection=await self.conn
        async with connection.transaction():
            for _sql in sql.split(';')[:-1]:
                await connection.execute(_sql)