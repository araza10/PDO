package org.openmrs.module.codbr.fragment.controller.content;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Encounter;
import org.openmrs.Form;
import org.openmrs.Patient;
import org.openmrs.Visit;
import org.openmrs.api.context.Context;
import org.openmrs.module.htmlformentry.FormEntryContext;
import org.openmrs.module.htmlformentry.FormEntrySession;
import org.openmrs.module.htmlformentry.FormSubmissionError;
import org.openmrs.module.htmlformentry.HtmlForm;
import org.openmrs.module.htmlformentry.HtmlFormEntryUtil;
import org.openmrs.module.htmlformentry.FormEntryContext.Mode;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentActionRequest;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.openmrs.ui.framework.resource.ResourceFactory;
import org.springframework.web.bind.annotation.RequestParam;

public class EnterHtmlFormVerbalFragmentController {
	
	protected final Log log = LogFactory.getLog(EnterHtmlFormFragmentController.class);

	public void controller(/*@FragmentParam("patient") Patient patient,*/
						   @FragmentParam(value = "formUuid", required = false) String formUuid,
						   @FragmentParam(value = "encounter", required = false) Encounter encounter,
						   @FragmentParam(value = "visit", required = false) Visit visit,
						   @FragmentParam(value = "returnUrl", required = false) String returnUrl,
						   FragmentConfiguration config,
						   FragmentModel model,
						   HttpSession httpSession,
						   PageRequest pageRequest,
						   @SpringBean ResourceFactory resourceFactory) throws Exception {


		
		Patient patient = Context.getPatientService().getPatient(2);
		// Get html form from database or UI resource
		HtmlForm hf = HtmlFormEntryUtil.getService().getHtmlForm(16);
		


		// The code below doesn't handle the HFFS case where you might want to _add_ data to an existing encounter
		FormEntrySession fes;
		if (encounter != null) {
			fes = new FormEntrySession(patient, encounter, Mode.EDIT, hf, httpSession);
		}
		else {
			fes = new FormEntrySession(patient, hf, httpSession);
		}

		if (returnUrl != null) {
			fes.setReturnUrl(returnUrl);
		}

		// Ensure we've generated the form's HTML (and thus set up the submission actions, etc) before we do anything
		fes.getHtmlToDisplay();

		//Context.setVolatileUserData(FORM_IN_PROGRESS_KEY, session);

		model.addAttribute("command", fes);
		
	}

	/**
	 * Handles a form submission
	 * @return form errors in a simple object
	 * @throws Exception
	 */
	 
	public Object submit(@RequestParam("personId") Patient patient,
						 @RequestParam("formId") Form form,
						 @RequestParam(value = "encounterId", required = false) Encounter encounter,
						 @RequestParam(value = "returnUrl", required = false) String returnUrl,
						 @SpringBean ResourceFactory resourceFactory,
												 FragmentActionRequest actionRequest) throws Exception {

		// TODO formModifiedTimestamp and encounterModifiedTimestamp

		

		// Get html form from database or UI resource
		HtmlForm hf = HtmlFormEntryUtil.getService().getHtmlForm(2);
		FormEntryContext context ;
		FormEntrySession fes;
		if (encounter != null) {
			fes = new FormEntrySession(patient, encounter, Mode.EDIT, hf, actionRequest.getHttpRequest().getSession());
		} else {
			fes = new FormEntrySession(patient, hf, Mode.ENTER, actionRequest.getHttpRequest().getSession());
		}

		if (returnUrl != null) {
			fes.setReturnUrl(returnUrl);
		}

		// Ensure we've generated the form's HTML (and thus set up the submission actions, etc) before we do anything
		fes.getHtmlToDisplay();
		
		// Validate submission
		List<FormSubmissionError> validationErrors = fes.getSubmissionController().validateSubmission(fes.getContext(), actionRequest.getHttpRequest());
		context = fes.getContext();
		// If there are validation errors, abort submit and display them
		if (validationErrors.size() > 0) {
			return returnHelper(validationErrors, fes.getContext());
		}

		// No validation errors found so continue process of form submission
		fes.prepareForSubmit();
		fes.getSubmissionController().handleFormSubmission(fes, actionRequest.getHttpRequest());

		// Check this form will actually create an encounter if its supposed to
		if (fes.getContext().getMode() == Mode.ENTER && fes.hasEncouterTag() && (fes.getSubmissionActions().getEncountersToCreate() == null || fes.getSubmissionActions().getEncountersToCreate().size() == 0)) {
			throw new IllegalArgumentException("This form is not going to create an encounter");
		}

		// Get the encounter that will be saved
		Encounter formEncounter = fes.getContext().getMode() == Mode.ENTER ? fes.getSubmissionActions().getEncountersToCreate().get(0) : encounter;



		// Once again, if there are validation errors, abort submit and display them
		if (validationErrors.size() > 0) {
			return returnHelper(validationErrors, fes.getContext());
		}

		// Do actual encounter creation/updating
		fes.applyActions();

		return returnHelper(null, null);
	}

	/**
	 *
	 * @param validationErrors
	 * @param context
	 * @return
	 */
	private SimpleObject returnHelper(List<FormSubmissionError> validationErrors, FormEntryContext context) {
		if (validationErrors == null || validationErrors.size() == 0) {
			return SimpleObject.create("success", true);
		} else {
			Map<String, String> errors = new HashMap<String, String>();
			for (FormSubmissionError err : validationErrors) {
				if (err.getSourceWidget() != null)
					errors.put(context.getErrorFieldId(err.getSourceWidget()), err.getError());
				else
					errors.put(err.getId(), err.getError());
			}
			return SimpleObject.create("success", false, "errors", errors);
		}
	}



}
