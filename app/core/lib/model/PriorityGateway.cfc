<cfcomponent
	output="false"
	hint="I provide data access methods for the priority entity.">

	<cffunction name="getPriorityByFilter" access="public" returnType="array">

		<cfargument name="id" type="numeric" required="false" />

		<cfquery name="local.results" result="local.metaResults" returnType="array">
			/* DEBUG: priorityGateway.getPriorityByFilter() */
			SELECT
				id,
				name,
				description
			FROM
				priority
			WHERE
				TRUE

			<cfif arguments.keyExists( "id" )>
				AND
					id = <cfqueryparam value="#id#" cfsqltype="cf_sql_tinyint" />
			</cfif>

			ORDER BY
				id ASC
			;
		</cfquery>

		<cfreturn results />

	</cffunction>

</cfcomponent>
