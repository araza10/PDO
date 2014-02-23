package org.openmrs.module.codbr.fragment.controller;
 
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Form;
import org.openmrs.Location;
import org.openmrs.Patient;
import org.openmrs.api.EncounterService;
import org.openmrs.api.context.Context;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.FragmentParam;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import com.mysql.jdbc.StringUtils;
 
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
 
public class LocationBasedReportEncountersFragmentController {
 
    private Date defaultStartDate() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        
        cal.add(Calendar.DATE, -1000);
        
        return cal.getTime();
    }
 
    private Date defaultEndDate(Date startDate) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(startDate);
        cal.add(Calendar.DAY_OF_MONTH, 1);
        cal.add(Calendar.MILLISECOND, -1);
        return cal.getTime();
    }
 
    public void controller(FragmentModel model,
                           @SpringBean("encounterService") EncounterService service,
                           @FragmentParam(value="start", required=false) Date startDate,
                           @FragmentParam(value="end", required=false) Date endDate) {
 
        if (startDate == null)
            startDate = defaultStartDate();
        if (endDate == null)
            endDate = defaultEndDate(startDate);
 
        System.out.println("HERE IN ENCOUNTERS CONTROLLER....");
		List<Encounter> list = Context.getEncounterService().getEncounters(null, null , startDate, endDate, null, null, null, null, null, true);
        model.addAttribute("encounters", list);
        model.addAttribute("encounterTypes", Context.getEncounterService().getAllEncounterTypes());
        model.addAttribute("formTypes", Context.getFormService().getAllForms());
    }
    
    /**
     * Fragment Action for fetching list of active patient identifiers
     */
    public List<SimpleObject> getEncounters(@RequestParam(value="locationName", required=false) String locationName,
            @RequestParam(value="properties", required=false) String[] properties,
            @RequestParam(value="encounterType", required=false) String encounterType,
            @RequestParam(value="formType", required=false) String formType,
            UiUtils ui) {

    	System.out.println("HERE IN ENCOUNTERS....::"+locationName+":"+encounterType+":"+formType);
    	
        Location loc = Context.getLocationService().getLocation(locationName);
        ArrayList<EncounterType> enctl = new ArrayList<EncounterType>();
        enctl.add(Context.getEncounterService().getEncounterType(encounterType));
        
        ArrayList<Form> forml = new ArrayList<Form>();
        forml.add(Context.getFormService().getForm(formType));

		List<Encounter> list = Context.getEncounterService().getEncounters(null, loc, null, null, 
				(StringUtils.isEmptyOrWhitespaceOnly(formType)?null:forml), 
				(StringUtils.isEmptyOrWhitespaceOnly(encounterType)?null:enctl), null, null, null, false);
        
		if (properties == null) {
            properties = new String[] { "patient", "form", "encounterType", "encounterDatetime", "location", "provider" };
        }

		return SimpleObject.fromCollection(list, ui, "patient", "form", "encounterType", "encounterDatetime", "location", "provider");
    }
}