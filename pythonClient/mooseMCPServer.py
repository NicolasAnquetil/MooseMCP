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
def listEntitiesForType(entityType : str) -> list[str]:
    """Lists all the entities of a given type in a project
    Args:
        The name of an entity type as a string
    Returns:
        A list of strings naming all the entities of the given type in a moose project."""

    return callMooseServer('list:entitiesForType', [entityType])

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
def listEntityClients(entity : str) -> list[str]:
     """Lists all the clients of an entity, ie. all other entities that depend on this one
     Args:
        A string naming an entity
     Returns:
        A list of strings naming all the clients of the given entity."""

     return callMooseServer('list:entityClients', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def listEntityProviders(entity : str) -> list[str]:
     """Lists all the clients of an entity, ie. all other entities that this one depends on
     Args:
        A string naming an entity
     Returns:
        A list of strings naming all the providers for the given entity."""

     return callMooseServer('list:entityProviders', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def listEntityParents(entity : str) -> list[str]:
     """Lists all the parents of an entity. Typically there is only one parent per entity
     Args:
        A string naming an entity
     Returns:
        A list of strings naming all the parents for the given entity."""

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
@mcp.tool()
def listEntityProperty(entity : str)-> list[str]:
    """CLists all the properties of an entity.
     Args:
        A string naming an entity
     Returns:
        A list of strings naming all the properties for the given entity."""

    return callMooseServer('list:entityProperties', [entity])

#----------------------------------------------------------------------------
# T O O L S -- R E Q U E S T S
#----------------------------------------------------------------------------


#----------------------------------------------------------------------------
@mcp.tool()
def requestEntitylName(entity : str) -> str:
    """Gets the fully qualified name of the entity in parameter
    Args:
        A string naming an entity
    Returns:
        A string with the fully qualified name of the given entity."""

    return callMooseServer('request:entityName', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def requestEntityType(entity : str) -> str:
    """Gets the type of the entity in parameter
    Args:
        A string naming an entity
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
def requestModelSize() -> str:
    """Gets the number of entities in a moose project
    Args:
        None
    Returns:
        The total number of entities in the project."""

    return callMooseServer('request:modelSize', [])

#----------------------------------------------------------------------------
# T O O L S -- P R O P E R T I E S
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
@mcp.tool()
def metricPackageCohesion(entity : str) -> float:
    """Gets the cohesion (as defined by the Robert C. Martin) of the package in parameter.
    Martin's cohesion ranges between 0 and 1, the higher the better.
    Args:
        A string naming a package
    Returns:
        Martin's cohesion for the package in parameter."""

    return callMooseServer('property:packageCohesion', [entity])


#----------------------------------------------------------------------------
@mcp.tool()
def metricPackageCoupling(entity : str) -> int:
    """Gets the efferent coupling (as defined by the Robert C. Martin) of the package in parameter.
    Martin's efferent coupling is a positive integer, the lower the better.
    Args:
        A string naming a package
    Returns:
        Martin's efferent coupling for the package in parameter."""

    return callMooseServer('property:packageCoupling', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def metricClassLackOfCohesion(entity : str) -> float:
    """Gets the value of the Lack of Cohesion (LCOM) metric for the class in parameter.
    Args:
        A string naming a class
    Returns:
        LCOM value for the class in parameter."""

    return callMooseServer('property:classLackOfCohesion', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def metricMethodNumberOfStatements(entity : str) -> float:
    """Gets the number of statements for the method in parameter.
    Args:
        A string naming a method
    Returns:
        Number of statements for the method in parameter."""

    return callMooseServer('property:methodNumberOfStatements', [entity])

#----------------------------------------------------------------------------
@mcp.tool()
def metricMethodCyclomaticComplexity(entity : str) -> float:
    """Gets the cyclomatic complexity for the method in parameter.
    Args:
        A string naming a method
    Returns:
        Cyclomatic complexity value for the method in parameter."""

    return callMooseServer('property:methodCyclomaticComplexity', [entity])


#----------------------------------------------------------------------------
@mcp.tool()
def hasProperty(entity : str, property : str) -> bool:
    """Check whether a given entity has a given property.
    Args:
        - A string naming an entity
        - A property name
    Returns:
        true or false, whther the entity has the given property or not."""

    return callMooseServer('property:hasProperty', [entity, property])

#----------------------------------------------------------------------------
# T O O L S -- M I S C
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
@mcp.tool()
def memorySet(name : str, entities : list[str]) -> int:
    """Associates a key to a list of entities.
    Args:
        - A key
        - A list of entities
    Returns:
        The number of entities in the list."""

    return callMooseServer('memory:set', [name, entities])

#----------------------------------------------------------------------------
@mcp.tool()
def memoryGet(name : str) -> list[str]:
    """Recovers a list of entities from its associated key
    Args:
        The key associated to the list
    Returns:
        A list of entities"""

    return callMooseServer('memory:get', [name])

#----------------------------------------------------------------------------
# R E S O U R C E S
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
# U T I L I T I E S
#----------------------------------------------------------------------------
def callMooseServer(command: str, args: list):

    #logger.info(f"callMooseServer: '{command}' with '{args}'")

    payload = {
        "method": command,
        "params": args,
        "jsonrpc": "2.0",
        "id": 1,
    }

    response = requests.post(
        url, data=json.dumps(payload), headers=headers).json()

    #logger.info(f"  response to {command} -> {response}")

    return response["result"]


#----------------------------------------------------------------------------
if __name__ == "__main__":

    url = "http://localhost:4444/"
    headers = {'content-type': 'application/json'}

    mcp.run(transport="stdio")
