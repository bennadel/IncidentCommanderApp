component
	output = false
	hint = "I provide validation methods for the priority entity."
	{

	/**
	* I throw a priority not found error.
	*/
	public void function throwPriorityNotFoundError() {

		throw( type = "App.Model.Priority.NotFound" );

	}

}
