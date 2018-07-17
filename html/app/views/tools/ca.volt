<div class="row">
  <div class="col-lg-12">
    {{ content() }}
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <h2>About this CA</h2>
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <p>Display CA Certificates per Profile. Please select Profile first!</p>
  </div>
</div>

<form method="POST">
  <div class="row">
    <div class="col-lg-8">
      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text" id="basic-addon1">CA-Profile</span>
        </div>
        {{ form.render("profile") }}
      </div>
    </div>
    <div class="col-lg-4">
      {{ submit_button("Go", "class": "btn btn-light form-control") }}
    </div>
  </div>
</form>

{% if request.isPost()%}
<div class="row">
  <div class="col-lg-12">
    <h5>USAGES</h5>
    <ul>
    {% for usage in cainfo["usages"] %}
      <li>{{ usage }}</li>
    {% endfor %}
    </ul>
  </div>
</div>
<div class="row">
  <div class="col-lg-12">
    <textarea rows="20" class="form-control" disabled>{{ cainfo["certificate"] }}</textarea>
  </div>
</div>
{% endif %}
