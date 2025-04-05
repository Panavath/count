class DoesNotExistException(Exception):
    """Raised when the database cannot find any item with the query."""

class NoFoodDetectedException(Exception):
    """Raised when the model cannot find any foods in an image."""

class NoFoodEdamamException(Exception):
    """Raised when the model cannot find any foods in an image."""
