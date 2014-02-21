<% ui.decorateWith("codbr","standardPage") 
	
%>


<div id="featured-wrapper">
	<div id="featured" class="container">
		<div class="major">
			<span class="byline">Choose one of the following options</span>
		</div>

		<div class="home-app-container">

		<div class="home-app-links">
			<span class="icon icon-data-entry"></span>
			<div class="title">
				<a href ="${ui.pageLink("codbr", "dataEntryHome")}"><h2>DATA ENTRY</h2></a>
				<span class="byline">Fill any of the following forms: Birth Record, Medical Record of Death, Verbal Autopsy...</span>
			</div>
		</div>
		<div class="home-app-links">
			<span class="icon icon-search"></span>
			<div class="title">
				<h2>SEARCH</h2>
				<span class="byline">Find individual birth, death, VA records....</span>
			</div>
		</div>
		<div class="home-app-links">
			<span class="icon icon-report"></span>
			<div class="title">
				<a href="/openmrs/module/birt/report.list"><h2>REPORTS</h2></a>
				<span class="byline">Generate reports using...</span>
			</div>
		</div>
		<div class="home-app-links">
			<span class="icon icon-audit"></span>
			<div class="title">
				<a href="/openmrs/admin/users/users.list"><h2>USER DATABASE</h2></a>
				<span class="byline">View a list of system users and their assigned roles</span>
			</div>
		</div>
		
	</div>
	</div>
</div>
