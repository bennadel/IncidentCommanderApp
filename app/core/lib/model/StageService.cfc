component
	output = false
	hint = "I provide service methods for the stage entity."
	{

	// Define properties for dependency-injection.
	property name="gateway" ioc:type="core.lib.model.StageGateway";
	property name="validation" ioc:type="core.lib.model.StageValidation";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I get the stage entity with the given ID.
	*/
	public struct function getStage( required numeric id ) {

		var results = gateway.getStageByFilter( id = id );

		if ( ! results.len() ) {

			validation.throwStageNotFoundError();

		}

		return results.first();

	}


	/**
	* I get the stage entities that match the given filters.
	*/
	public array function getStageByFilter(
		numeric id
		) {

		return gateway.getStageByFilter( argumentCollection = arguments );

	}

}
