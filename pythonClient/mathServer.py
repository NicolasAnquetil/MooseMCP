from mcp.server.fastmcp import FastMCP
import logging

mcp = FastMCP(name="MooseMCPServer")

logging.basicConfig(filename='mooseMCP.log', level=logging.INFO)
logger = logging.get_logger(__name__)

#----------------------------------------------------------------------------
@mcp.tool()
def add(a: float, b: float) -> float:
    """Adds two numbers
    Args:
        a: The first number
        b: The second number
    Returns:
        The sum of the two numbers."""

    logger.info(f"mathServer: {a} + {b}")
    return a + b

#----------------------------------------------------------------------------
@mcp.tool()
def substract(a: float, b: float) -> float:
    """Adds two numbers
    Args:
        a: The first number
        b: The second number
    Returns:
        The first number minus the second number."""

    logger.info(f"mathServer: {a} - {b}")
    return a - b

#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
@mcp.tool()
def greaterThan(a: float, b: float) -> bool:
    """Compare two numbers
    Args:
        a: The first number
        b: The second number
    Returns:
        Whether the first number is larger than the second number."""

    logger.info(f"mathServer: {a} > {b}")
    return a > b


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
