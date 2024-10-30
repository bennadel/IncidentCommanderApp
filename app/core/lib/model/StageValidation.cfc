component
	output = false
	hint = "I provide validation methods for the stage entity."
	{

	/**
	* I throw a stage not found error.
	*/
	public void function throwStageNotFoundError() {

		throw( type = "App.Model.Stage.NotFound" );

	}

}
