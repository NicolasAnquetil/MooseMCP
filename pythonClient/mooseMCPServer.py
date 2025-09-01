from mcp.server.fastmcp import FastMCP
import requests
import json
from mcp.server.fastmcp.utilities.logging import get_logger
 

mcp = FastMCP(name="MooseMCPServer")

logger = get_logger(__name__)
#file_handler = logging.FileHandler('mooseMCPServerPy.log')
#logger.addHandler(file_handler)

#----------------------------------------------------------------------------
@mcp.tool()
def listEntitiesForType(entityType : str) -> list[str]:
     """Lists all the entities of a given type in a project
     Args:
         The name of an entity type as a string
     Returns:
         A list of strings naming all the entities of the given type in a moose project."""

     return callMooseServer('list:entitiesForType', [entityType])

#----------------------------------------------------------------------------
@mcp.tool()
def requestModelName() -> str:
    """Gets the name of the current moose project
    Args:
        None
    Returns:
        A string naming the current project."""

    return callMooseServer('request:modelName', [])

#----------------------------------------------------------------------------
@mcp.tool()
def listEntityTypes() -> list[str]:
    """Lists all the types of entities in a moose project
    Args:
        None
    Returns:
        A list of strings naming all the entity types in the project."""

    return callMooseServer('list:entityTypes', [])

#----------------------------------------------------------------------------
@mcp.tool()
def listEntityChildren(entity : str) -> list[str]:
     """Lists all the children of an entity
     Args:
         A string naming an entity
     Returns:
         A list of strings naming all the children of the given entity."""

     return callMooseServer('list:entityChildren', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def requestModelSize() -> int:
    """Gets the number of entities in a moose project
    Args:
        None
    Returns:
        The total number of entities in the project."""

    return callMooseServer('request:modelSize', [])

#----------------------------------------------------------------------------
@mcp.tool()
def requestModelRepository() -> str:
    """Gets the repository of a moose project
    Args:
        None
    Returns:
        The github repository of the project."""

    return callMooseServer('request:modelRepository', [])


#----------------------------------------------------------------------------
def callMooseServer(command: str, args: list):

    logger.info(f"callMooseServer: '{command}' with '{args}'")

    payload = {
        "method": command,
        "params": args,
        "jsonrpc": "2.0",
        "id": 1,
    }

    response = requests.post(
        url, data=json.dumps(payload), headers=headers).json()

    logger.info(f"  response to {command} -> {response}")

    return response["result"]


#----------------------------------------------------------------------------
if __name__ == "__main__":

    url = "http://localhost:4444/"
    headers = {'content-type': 'application/json'}

    mcp.run(transport="stdio")
