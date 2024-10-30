<cfcomponent
	output="false"
	hint="I provide data access methods for the status entity.">

	<cffunction name="createStatus" access="public" returnType="numeric">

		<cfargument name="incidentID" type="numeric" required="true" />
		<cfargument name="stageID" type="numeric" required="true" />
		<cfargument name="contentMarkdown" type="string" required="true" />
		<cfargument name="contentHtml" type="string" required="true" />
		<cfargument name="createdAt" type="date" required="true" />

		<cfquery name="local.results" result="local.metaResults">
			/* DEBUG: statusGateway.createStatus() */
			INSERT INTO
				status_update
			SET
				incidentID = <cfqueryparam value="#incidentID#" cfsqltype="cf_sql_bigint" />,
				stageID = <cfqueryparam value="#stageID#" cfsqltype="cf_sql_tinyint" />,
				contentMarkdown = <cfqueryparam value="#contentMarkdown#" cfsqltype="cf_sql_longvarchar" />,
				contentHtml = <cfqueryparam value="#contentHtml#" cfsqltype="cf_sql_longvarchar" />,
				createdAt = <cfqueryparam value="#createdAt#" cfsqltype="cf_sql_timestamp" />
			;
		</cfquery>

		<cfreturn metaResults.generatedkey />

	</cffunction>


	<cffunction name="deleteStatusByFilter" access="public" returnType="void">

		<cfargument name="id" type="numeric" required="false" />
		<cfargument name="incidentID" type="numeric" required="false" />

		<cfif (
			isNull( id ) &&
			isNull( incidentID )
			)>

			<cfthrow
				type="DangerousSql"
				message="At least one indexed column is required for safe filtering."
			/>

		</cfif>

		<cfquery name="local.results" result="local.metaResults" returnType="array">
			/* DEBUG: statusGateway.deleteStatusByFilter() */
			DELETE FROM
				status_update
			WHERE
				TRUE

			<cfif arguments.keyExists( "id" )>
				AND
					id = <cfqueryparam value="#id#" cfsqltype="cf_sql_bigint" />
			</cfif>

			<cfif arguments.keyExists( "incidentID" )>
				AND
					incidentID = <cfqueryparam value="#incidentID#" cfsqltype="cf_sql_bigint" />
			</cfif>
			;
		</cfquery>

	</cffunction>


	<cffunction name="getStatusByFilter" access="public" returnType="array">

		<cfargument name="id" type="numeric" required="false" />
		<cfargument name="incidentID" type="numeric" required="false" />

		<cfif (
			isNull( id ) &&
			isNull( incidentID )
			)>

			<cfthrow
				type="DangerousSql"
				message="At least one indexed column is required for safe filtering."
			/>

		</cfif>

		<cfquery name="local.results" result="local.metaResults" returnType="array">
			/* DEBUG: statusGateway.getStatusByFilter() */
			SELECT
				id,
				incidentID,
				stageID,
				contentMarkdown,
				contentHtml,
				createdAt
			FROM
				status_update
			WHERE
				TRUE

			<cfif arguments.keyExists( "id" )>
				AND
					id = <cfqueryparam value="#id#" cfsqltype="cf_sql_bigint" />
			</cfif>

			<cfif arguments.keyExists( "incidentID" )>
				AND
					incidentID = <cfqueryparam value="#incidentID#" cfsqltype="cf_sql_bigint" />
			</cfif>

			ORDER BY
				id ASC
			;
		</cfquery>

		<cfreturn results />

	</cffunction>


	<cffunction name="updateStatus" access="public" returnType="void">

		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="stageID" type="numeric" required="false" />
		<cfargument name="contentMarkdown" type="string" required="false" />
		<cfargument name="contentHtml" type="string" required="false" />

		<cfquery name="local.results" result="local.metaResults">
			/* DEBUG: statusGateway.updateStatus() */
			UPDATE
				status_update
			SET
				<cfif arguments.keyExists( "stageID" )>
					stageID = <cfqueryparam value="#stageID#" cfsqltype="cf_sql_tinyint" />,
				</cfif>

				<cfif arguments.keyExists( "contentMarkdown" )>
					contentMarkdown = <cfqueryparam value="#contentMarkdown#" cfsqltype="cf_sql_longvarchar" />,
				</cfif>

				<cfif arguments.keyExists( "contentHtml" )>
					contentHtml = <cfqueryparam value="#contentHtml#" cfsqltype="cf_sql_longvarchar" />,
				</cfif>

				id = id
			WHERE
				id = <cfqueryparam value="#id#" cfsqltype="cf_sql_bigint" />
			;
		</cfquery>

	</cffunction>

</cfcomponent>
