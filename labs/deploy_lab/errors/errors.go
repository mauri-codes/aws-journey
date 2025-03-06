package custom_error

type CustomError struct {
	Message string
	Code    string
	Details string
}

type ICustomError interface {
	error
	GetCode() string
	GetDetails() string
}

func (err *CustomError) Error() string {
	return err.Message
}

func (err *CustomError) GetCode() string {
	return err.Code
}

func (err *CustomError) GetDetails() string {
	return err.Details
}

func (err *CustomError) SetDetails(details string) {
	err.Details = details
}

func NewCustomError(code string, message string) ICustomError {
	return &CustomError{
		Code:    code,
		Message: message,
	}
}

func NewCustomDetailedError(code string, message string, details string) ICustomError {
	return &CustomError{
		Code:    code,
		Message: message,
		Details: details,
	}
}
