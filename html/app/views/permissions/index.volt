<div class="row">
	<div class="col-lg-12">
		{{ content() }}
	</div>
</div>

<div class="row">
	<h2>Manage Permissions</h2>
</div>

<form method="post">

<div class="row">
	<div class="col-lg-6">
		<div class="input-group mb-3">
			<div class="input-group-prepend">
				<span class="input-group-text" id="basic-addon1">Profile</span>
			</div>
			{{ select('profileId', profiles, 'using': ['id', 'name'], 'useEmpty': true, 'emptyText': 'Select', 'emptyValue': '', 'class': 'form-control') }}
		</div>
	</div>
	<div class="col-lg-6">
		<td>{{ submit_button('Search', 'class': 'btn btn-light form-control', 'name' : 'search') }}</td>
	</div>
</div>
{% if request.isPost() and profile %}
	{% for resource, actions in acl.getResources() %}
		<div class="row">
			<div class="col-lg-12">
				<h3>{{ resource }}</h3>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<table class="table table-hover" align="center">
					<thead>
						<tr>
							<th width="5%"></th>
							<th>Description</th>
						</tr>
					</thead>
					<tbody>
						{% for action in actions %}
						<tr>
							<td align="center"><input type="checkbox" name="permissions[]" value="{{ resource ~ '.' ~ action }}"  {% if permissions[resource ~ '.' ~ action] is defined %} checked="checked" {% endif %}></td>
							<td>{{ acl.getActionDescription(action) ~ ' ' ~ resource }}</td>
						</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		</div>
	{% endfor %}
	<div class="row">
		<div class="col-lg-12">
			{{ submit_button('Save', 'class': 'btn btn-success form-control', 'name':'submit') }}
		</div>
	</div>
{% endif %}
</form>
