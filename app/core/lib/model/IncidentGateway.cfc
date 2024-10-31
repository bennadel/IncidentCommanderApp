<cfcomponent
	output="false"
	hint="I provide data access methods for the incident entity.">

	<cffunction name="createIncident" access="public" returnType="numeric">

		<cfargument name="slug" type="string" required="true" />
		<cfargument name="description" type="string" required="true" />
		<cfargument name="ownership" type="string" required="true" />
		<cfargument name="priorityID" type="numeric" required="true" />
		<cfargument name="ticketUrl" type="string" required="true" />
		<cfargument name="videoUrl" type="string" required="true" />
		<cfargument name="createdAt" type="date" required="true" />

		<cfquery name="local.results" result="local.metaResults">
			/* DEBUG: incidentGateway.createIncident() */
			INSERT INTO
				incident
			SET
				slug = <cfqueryparam value="#slug#" cfsqltype="cf_sql_varchar" />,
				description = <cfqueryparam value="#description#" cfsqltype="cf_sql_varchar" />,
				ownership = <cfqueryparam value="#ownership#" cfsqltype="cf_sql_varchar" />,
				priorityID = <cfqueryparam value="#priorityID#" cfsqltype="cf_sql_tinyint" />,
				ticketUrl = <cfqueryparam value="#ticketUrl#" cfsqltype="cf_sql_varchar" />,
				videoUrl = <cfqueryparam value="#videoUrl#" cfsqltype="cf_sql_varchar" />,
				createdAt = <cfqueryparam value="#createdAt#" cfsqltype="cf_sql_timestamp" />
			;
		</cfquery>

		<cfreturn metaResults.generatedkey />

	</cffunction>


	<cffunction name="deleteIncidentByFilter" access="public" returnType="void">

		<cfargument name="id" type="numeric" required="false" />

		<cfif isNull( id )>

			<cfthrow
				type="DangerousSql"
				message="At least one indexed column is required for safe filtering."
			/>

		</cfif>

		<cfquery name="local.results" result="local.metaResults" returnType="array">
			/* DEBUG: incidentGateway.deleteIncidentByFilter() */
			DELETE FROM
				incident
			WHERE
				TRUE

			<cfif arguments.keyExists( "id" )>
				AND
					id = <cfqueryparam value="#id#" cfsqltype="cf_sql_bigint" />
			</cfif>
			;
		</cfquery>

	</cffunction>


	<cffunction name="getIncidentByFilter" access="public" returnType="array">

		<cfargument name="id" type="numeric" required="false" />
		<cfargument name="slug" type="string" required="false" />

		<cfif isNull( id )>

			<cfthrow
				type="DangerousSql"
				message="At least one indexed column is required for safe filtering."
			/>

		</cfif>

		<cfquery name="local.results" result="local.metaResults" returnType="array">
			/* DEBUG: incidentGateway.getIncidentByFilter() */
			SELECT
				id,
				slug,
				description,
				ownership,
				priorityID,
				ticketUrl,
				videoUrl,
				createdAt
			FROM
				incident
			WHERE
				TRUE

			<cfif arguments.keyExists( "id" )>
				AND
					id = <cfqueryparam value="#id#" cfsqltype="cf_sql_bigint" />
			</cfif>

			<cfif arguments.keyExists( "slug" )>
				AND
					slug = <cfqueryparam value="#slug#" cfsqltype="cf_sql_varchar" />
			</cfif>

			ORDER BY
				id ASC
			;
		</cfquery>

		<cfreturn results />

	</cffunction>


	<cffunction name="updateIncident" access="public" returnType="void">

		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="description" type="string" required="false" />
		<cfargument name="ownership" type="string" required="false" />
		<cfargument name="priorityID" type="numeric" required="false" />
		<cfargument name="ticketUrl" type="string" required="false" />
		<cfargument name="videoUrl" type="string" required="false" />

		<cfquery name="local.results" result="local.metaResults">
			/* DEBUG: incidentGateway.updateIncident() */
			UPDATE
				incident
			SET
				<cfif arguments.keyExists( "description" )>
					description = <cfqueryparam value="#description#" cfsqltype="cf_sql_varchar" />,
				</cfif>

				<cfif arguments.keyExists( "ownership" )>
					ownership = <cfqueryparam value="#ownership#" cfsqltype="cf_sql_varchar" />,
				</cfif>

				<cfif arguments.keyExists( "priorityID" )>
					priorityID = <cfqueryparam value="#priorityID#" cfsqltype="cf_sql_tinyint" />,
				</cfif>

				<cfif arguments.keyExists( "ticketUrl" )>
					ticketUrl = <cfqueryparam value="#ticketUrl#" cfsqltype="cf_sql_varchar" />,
				</cfif>

				<cfif arguments.keyExists( "videoUrl" )>
					videoUrl = <cfqueryparam value="#videoUrl#" cfsqltype="cf_sql_varchar" />,
				</cfif>

				id = id
			WHERE
				id = <cfqueryparam value="#id#" cfsqltype="cf_sql_bigint" />
			;
		</cfquery>

	</cffunction>

</cfcomponent>
