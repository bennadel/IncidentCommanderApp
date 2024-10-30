component
	output = false
	hint = "I provide service methods for the priority entity."
	{

	// Define properties for dependency-injection.
	property name="gateway" ioc:type="core.lib.model.PriorityGateway";
	property name="validation" ioc:type="core.lib.model.PriorityValidation";

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I get the priority entity with the given ID.
	*/
	public struct function getPriority( required numeric id ) {

		var results = gateway.getPriorityByFilter( id = id );

		if ( ! results.len() ) {

			validation.throwPriorityNotFoundError();

		}

		return results.first();

	}


	/**
	* I get the priority entities that match the given filters.
	*/
	public array function getPriorityByFilter(
		numeric id
		) {

		return gateway.getPriorityByFilter( argumentCollection = arguments );

	}

}
