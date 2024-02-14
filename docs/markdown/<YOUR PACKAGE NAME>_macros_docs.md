{% docs macro_allow_refresh %}
{% raw %}
This macro is used to determine if a full-refresh is allowed (depending on the environment), using the `snowplow__allow_refresh` variable.

#### Returns
`snowplow__allow_refresh` if environment is not `dev`, `none` otherwise.

{% endraw %}
{% enddocs %}
