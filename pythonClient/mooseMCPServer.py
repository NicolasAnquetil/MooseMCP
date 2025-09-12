from mcp.server.fastmcp import FastMCP
import requests
import json
from mcp.server.fastmcp.utilities.logging import get_logger
 

mcp = FastMCP(name="MooseMCPServer")

logger = get_logger(__name__)
#file_handler = logging.FileHandler('mooseMCPServerPy.log')
#logger.addHandler(file_handler)


#----------------------------------------------------------------------------
# T O O L S -- L I S T
#----------------------------------------------------------------------------


#----------------------------------------------------------------------------
@mcp.tool()
def listEntitiesForType(entityType : str) -> list[int]:
     """Lists all the entities of a given type in a project
     Args:
         The name of an entity type as a string
     Returns:
         A list of ids of all the entities of the given type in a moose project."""

     return callMooseServer('list:entitiesForType', [entityType])

#----------------------------------------------------------------------------
@mcp.tool()
def listEntityChildren(entity : int) -> list[int]:
     """Lists all the children of an entity
     Args:
         The id of an entity
     Returns:
         A list of ids for all the children of the given entity."""

     return callMooseServer('list:entityChildren', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def listEntityClients(entity : int) -> list[int]:
     """Lists all the clients of an entity, ie. all other entities that depend on this one
     Args:
         An id for an entity
     Returns:
         A list of ids for all the clients of the given entity."""

     return callMooseServer('list:entityClients', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def listEntityProviders(entity : int) -> list[int]:
     """Lists all the clients of an entity, ie. all other entities that this one depends on
     Args:
         An id of an entity
     Returns:
         A list of ids for all the providers for the given entity."""

     return callMooseServer('list:entityProviders', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def listEntityParents(entity : int) -> list[int]:
     """Lists all the parents of an entity. Typically there is only one parent per entity
     Args:
         An id of an entity
     Returns:
         A list of ids for all the parents for the given entity."""

     return callMooseServer('list:entityParents', [entity])

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
# T O O L S -- R E Q U E S T S
#----------------------------------------------------------------------------


#----------------------------------------------------------------------------
@mcp.tool()
def requestEntitylName(entity : int) -> str:
    """Gets the fully qualified name of the entity in parameter
    Args:
        The id of an entity
    Returns:
        A string with the fully qualified name of the parameter."""

    return callMooseServer('request:entityName', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def requestEntityType(entity : int) -> str:
    """Gets the type of the entity in parameter
    Args:
        The id of an entity
    Returns:
        A string naming the type of the entity in parameter."""

    return callMooseServer('request:entityType', [entity])

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
def requestModelRepository() -> str:
    """Gets the github repository of a moose project
    Args:
        None
    Returns:
        The github repository of the project."""

    return callMooseServer('request:modelRepository', [])

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
def requestPackageCohesion(entity : int) -> float:
    """Gets the cohesion (as defined by the Robert C. Martin) of the package in parameter.
    Martin's cohesion ranges between 0 and 1, the higher the better.
    Args:
        An id of an entity
    Returns:
        Martin's cohesion for the entity in parameter."""

    return callMooseServer('request:packageCohesion', [entity])


#----------------------------------------------------------------------------
@mcp.tool()
def requestPackageCoupling(entity : int) -> int:
    """Gets the efferent coupling (as defined by the Robert C. Martin) of the package in parameter.
    Martin's efferent coupling is a positive integer, the lower the better.
    Args:
        An id of an entity
    Returns:
        Martin's efferent coupling for the parameter."""

    return callMooseServer('request:packageCohesion', [entity])




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
# R E S O U R C E
#----------------------------------------------------------------------------


#----------------------------------------------------------------------------
# `dict' return type automatically translates to mime_type="application/json"
@mcp.resource("resource://model-report")
def resourceModelReport() -> dict:
    """Provides a summary report on the model:
       - raw number of entities of various type (package, class, method)
       - number of 'large' entities
       - number of 'complex' entities."""
    
    return callMooseServer('resource:model-report', [])

#----------------------------------------------------------------------------
@mcp.resource( uri="resource://package-dsm", mime_type="image/png")
def resourcePackageDSM() -> bytes:
    """A picture of a Dependency Structural Matrix (DSM) of all the packages in the model."""
    
    return callMooseServer('resource:package-dsm', [])


#----------------------------------------------------------------------------
if __name__ == "__main__":

    url = "http://localhost:4444/"
    headers = {'content-type': 'application/json'}

    mcp.run(transport="stdio")
