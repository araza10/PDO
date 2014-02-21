<%
	ui.includeJavascript("codbr", "dwr-util.js")
	ui.includeJavascript("codbr", "kenyahfe.js")
%>

<script type="text/javascript" src="/${ contextPath }/moduleResources/htmlformentry/htmlFormEntry.js"></script>
<link href="/${ contextPath }/moduleResources/htmlformentry/htmlFormEntry.css" type="text/css" rel="stylesheet" />
<script src="/${ contextPath }/dwr/util.js?v=1.9.3.f535e9" type="text/javascript" ></script>
	<script src="/${ contextPath }/dwr/interface/DWRHtmlFormEntryService.js?v=1.9.3.f535e9" type="text/javascript" ></script>
	<script src="/${ contextPath }/moduleResources/htmlformentry/htmlFormEntry.js?v=1.9.3.f535e9" type="text/javascript" ></script>
	<link href="/${ contextPath }/moduleResources/htmlformentry/htmlFormEntry.css?v=1.9.3.f535e9" type="text/css" rel="stylesheet" />
	<link href="/${ contextPath }/moduleResources/htmlformentry/jquery-ui-1.8.17.custom.css?v=1.9.3.f535e9" type="text/css" rel="stylesheet" />
	<script src="/${ contextPath }/moduleResources/htmlformentry/jquery-1.4.2.min.js?v=1.9.3.f535e9" type="text/javascript" ></script>
	<script src="/${ contextPath }/moduleResources/htmlformentry/jquery-ui-1.8.17.custom.min.js?v=1.9.3.f535e9" type="text/javascript" ></script>

<script type="text/javascript">
	\$j = jQuery; // For backwards compatibility - some forms maybe using this to reference jQuery

	var propertyAccessorInfo = new Array();

	var beforeSubmit = new Array(); // a list of functions that will be executed before the submission of a form

	${ command.fieldAccessorJavascript }

	jQuery(function() {
		ui.confirmBeforeNavigating('#htmlform');

		<% if (config.defaultEncounterDate) { %>
		// Update blank encounter dates to default to visit start date or current date
		if (getValue('encounter-date.value') == '') {
			setDatetimeValue('encounter-date.value', new Date(${ config.defaultEncounterDate.time }));
		}
		<% } %>

		// Inject discard button
		jQuery('#discard-button').click(function() { ui.navigate('${ command.returnUrl }'); })
				.insertAfter(jQuery('input.submitButton'));
	});

	/**
	 * Submit button generated by HFE calls a method called 'submitHtmlForm' so we need to provide this
	 */
	function submitHtmlForm() {
			var form = jQuery('#htmlform');
			alert("This is teh form");
		jQuery.post(form.attr('action'), form.serialize(), function(result) {
			if (result.success) {
				ui.disableConfirmBeforeNavigating();

				if (returnUrl) {
					ui.navigate(returnUrl);
				}
				else {
					ui.reloadPage();
				}
			}
			else {
				// Show errors on form
				for (key in result.errors) {
					showError(key, result.errors[key]);
				}

				submitting = false;
			}
		}, 'json')
	
	
	
	
	
        	}
</script>



	<form id="htmlform" method="post" action="${ ui.actionLink("codbr", "content/enterHtmlFormFoetal", "submit") }">
		
		<input type="hidden" name="personId" value="${ command.patient.personId }"/>
		<input type="hidden" name="formId" value="${ command.form.formId }"/>
		<input type="hidden" name="formModifiedTimestamp" value="${ command.formModifiedTimestamp }"/>
		<input type="hidden" name="encounterModifiedTimestamp" value="${ command.encounterModifiedTimestamp }"/>
		<% if (command.encounter) { %>
			<input type="hidden" name="encounterId" value="${ command.encounter.encounterId }"/>
		<% } %>
			
		<% if (command.returnUrl) { %>
			<input type="hidden" name="returnUrl" value="${ command.returnUrl }"/>
		<% } %>
		<input type="hidden" name="closeAfterSubmission" value="${ config.closeAfterSubmission }"/>

		<div class="ke-panel-frame">
		

			<div class="ke-form-globalerrors" style="display: none; border-radius: 0" id="general-form-error"></div>

			<div style="background-color: white"><!-- Because not all forms use .ke-form-content like they should -->
				${ command.htmlToDisplay }
			</div>
		</div>

	</form>
</div>