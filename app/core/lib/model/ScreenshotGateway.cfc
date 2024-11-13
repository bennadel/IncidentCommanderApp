<cfcomponent
	output="false"
	hint="I provide data access methods for the screenshot entity.">

	<cffunction name="createScreenshot" access="public" returnType="numeric">

		<cfargument name="incidentID" type="numeric" required="true" />
		<cfargument name="statusID" type="numeric" required="true" />
		<cfargument name="mimeType" type="string" required="true" />
		<cfargument name="createdAt" type="date" required="true" />

		<cfquery name="local.results" result="local.metaResults">
			/* DEBUG: screenshotGateway.createScreenshot() */
			INSERT INTO
				screenshot
			SET
				incidentID = <cfqueryparam value="#incidentID#" cfsqltype="cf_sql_bigint" />,
				statusID = <cfqueryparam value="#statusID#" cfsqltype="cf_sql_bigint" />,
				mimeType = <cfqueryparam value="#mimeType#" cfsqltype="cf_sql_varchar" />,
				createdAt = <cfqueryparam value="#createdAt#" cfsqltype="cf_sql_timestamp" />
			;
		</cfquery>

		<cfreturn metaResults.generatedkey />

	</cffunction>


	<cffunction name="deleteScreenshotByFilter" access="public" returnType="void">

		<cfargument name="id" type="numeric" required="false" />
		<cfargument name="incidentID" type="numeric" required="false" />
		<cfargument name="statusID" type="numeric" required="false" />

		<cfif (
			isNull( id ) &&
			isNull( incidentID ) &&
			isNull( statusID )
			)>

			<cfthrow
				type="DangerousSql"
				message="At least one indexed column is required for safe filtering."
			/>

		</cfif>

		<cfquery name="local.results" result="local.metaResults" returnType="array">
			/* DEBUG: screenshotGateway.deleteScreenshotByFilter() */
			DELETE FROM
				screenshot
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

			<cfif arguments.keyExists( "statusID" )>
				AND
					statusID = <cfqueryparam value="#statusID#" cfsqltype="cf_sql_bigint" />
			</cfif>
			;
		</cfquery>

	</cffunction>


	<cffunction name="getScreenshotByFilter" access="public" returnType="array">

		<cfargument name="id" type="numeric" required="false" />
		<cfargument name="incidentID" type="numeric" required="false" />
		<cfargument name="statusID" type="numeric" required="false" />

		<cfif (
			isNull( id ) &&
			isNull( incidentID ) &&
			isNull( statusID )
			)>

			<cfthrow
				type="DangerousSql"
				message="At least one indexed column is required for safe filtering."
			/>

		</cfif>

		<cfquery name="local.results" result="local.metaResults" returnType="array">
			/* DEBUG: screenshotGateway.getScreenshotByFilter() */
			SELECT
				id,
				incidentID,
				statusID,
				mimeType,
				createdAt
			FROM
				screenshot
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

			<cfif arguments.keyExists( "statusID" )>
				AND
					statusID = <cfqueryparam value="#statusID#" cfsqltype="cf_sql_bigint" />
			</cfif>

			ORDER BY
				id ASC
			;
		</cfquery>

		<cfreturn results />

	</cffunction>

</cfcomponent>
