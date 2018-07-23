<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>Revoke
      "{% if cert.ca_label %}
        {{ cert.ca_label }}
      {% else %}
        {{ cert.serial_number }}
      {% endif %}
      "</h2>
  </div>
</div>

{{ form('class': 'form-search') }}
  <div class="row">
    <div class="col-lg-12">
      {{ form.render("serial_number") }}
      {{ form.render("authority_key_identifier") }}
      <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">Reason</span>
        </div>
        {{ form.render("reason") }}
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-6">
      {{ link_to("certificate/show/" ~ cert.serial_number, 'Go Back', "class": "btn btn-light form-control") }}
    </div>
    <div class="col-lg-6">
      <button type="submit" class="form-control btn btn-danger">Revoke</button>
    </div>
  </div>
</form>
