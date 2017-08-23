set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.1.00.08'
,p_default_workspace_id=>1880665973001338
,p_default_application_id=>254
,p_default_owner=>'SANDBOX'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/com_insum_placecomplete
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(137888084662405544)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM.INSUM.PLACECOMPLETE'
,p_display_name=>'Google Places Autocomplete'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'procedure render_autocomplete  (',
'    p_item in apex_plugin.t_item,',
'    p_plugin in apex_plugin.t_plugin,',
'    p_param in apex_plugin.t_item_render_param,',
'    p_result in out nocopy apex_plugin.t_item_render_result ) IS',
'',
'    subtype plugin_attr is varchar2(32767);',
'',
'    l_result apex_plugin.t_item_render_result;',
'    l_js_params varchar2(1000);',
'    l_onload_string varchar2(32767);',
'',
'    -- Plugin attributes',
'    l_api_key plugin_attr := p_plugin.attribute_01;',
'',
'    -- Component attributes',
'    l_action plugin_attr := p_item.attribute_01;',
'    l_address plugin_attr := p_item.attribute_02;',
'    l_city plugin_attr := p_item.attribute_03;',
'    l_state plugin_attr := p_item.attribute_04;',
'    l_zip plugin_attr := p_item.attribute_05;',
'    l_country plugin_attr := p_item.attribute_06;',
'    l_latitude plugin_attr := p_item.attribute_07;',
'    l_longitude plugin_attr := p_item.attribute_08;',
'    l_address_long plugin_attr := p_item.attribute_09;',
'    l_state_long plugin_attr := p_item.attribute_10;',
'    l_country_long plugin_attr := p_item.attribute_11;',
'    l_location_type plugin_attr := p_item.attribute_12;',
'',
'    -- Component type',
'    l_component_type plugin_attr := p_item.component_type_id;',
'',
'begin',
'',
'    -- Get API key for JS file name',
'    l_js_params := ''?key='' || l_api_key || ''&libraries=places'';',
'',
'    apex_javascript.add_library',
'          (p_name           => ''js'' || l_js_params',
'          ,p_directory      => ''https://maps.googleapis.com/maps/api/''',
'          ,p_skip_extension => true);',
'',
'    apex_javascript.add_library',
'      (p_name                  => ''jquery.ui.autoComplete''',
'      ,p_directory             => p_plugin.file_prefix);',
'',
'    -- For use with APEX 5.1 and up. Print input element.',
'    sys.htp.prn (apex_string.format(''<input type="text" %s size="%s" maxlength="%s"/>''',
'                                    , apex_plugin_util.get_element_attributes(p_item, p_item.name, ''text_field'')',
'                                    , p_item.element_width',
'                                    , p_item.element_max_length));',
'',
'l_onload_string :=',
'''',
'$("#%NAME%").placesAutocomplete({',
'  pageItems : {',
'    autoComplete : {',
'      %AUTOCOMPLETE_ID%',
'    },',
'    lat : {',
'      %LAT_ID%',
'    },',
'    lng : {',
'      %LNG_ID%',
'    },',
'    route : {',
'      %ROUTE_ID%',
'      %ROUTE_FORM%',
'    },',
'    locality : {',
'      %LOCALITY_ID%',
'      %LOCALITY_FORM%',
'    },',
'    administrative_area_level_1 : {',
'      %ADMINISTRATIVE_AREA_LEVEL_1_ID%',
'      %ADMINISTRATIVE_AREA_LEVEL_1_FORM%',
'    },',
'    postal_code : {',
'      %POSTAL_CODE_ID%',
'      %POSTAL_CODE_FORM%',
'    },',
'    country : {',
'      %COUNTRY_ID%',
'      %COUNTRY_FORM%',
'    }',
'  },',
'  %ACTION%',
'  %TYPE%',
'  %COMPONENT_TYPE%',
'});',
''';',
'    l_onload_string := replace(l_onload_string,''%NAME%'',p_item.name);',
'    l_onload_string := replace(l_onload_string, ''%AUTOCOMPLETE_ID%'', apex_javascript.add_attribute(''id'',  p_item.name));',
'    l_onload_string := replace(l_onload_string, ''%ROUTE_ID%'', apex_javascript.add_attribute(''id'',  l_address));',
'    l_onload_string := replace(l_onload_string, ''%ROUTE_FORM%'', apex_javascript.add_attribute(''form'',  CASE WHEN l_address_long = ''Y'' THEN ''long_name'' ELSE ''short_name'' END));',
'    l_onload_string := replace(l_onload_string, ''%LOCALITY_ID%'', apex_javascript.add_attribute(''id'',  l_city));',
'    l_onload_string := replace(l_onload_string, ''%LOCALITY_FORM%'', apex_javascript.add_attribute(''form'',  ''long_name''));',
'    l_onload_string := replace(l_onload_string, ''%ADMINISTRATIVE_AREA_LEVEL_1_ID%'', apex_javascript.add_attribute(''id'',  l_state));',
'    l_onload_string := replace(l_onload_string, ''%ADMINISTRATIVE_AREA_LEVEL_1_FORM%'', apex_javascript.add_attribute(''form'',  CASE WHEN l_state_long = ''Y'' THEN ''long_name'' ELSE ''short_name'' END));',
'    l_onload_string := replace(l_onload_string, ''%POSTAL_CODE_ID%'', apex_javascript.add_attribute(''id'',  l_zip));',
'    l_onload_string := replace(l_onload_string, ''%POSTAL_CODE_FORM%'', apex_javascript.add_attribute(''form'',  ''long_name''));',
'    l_onload_string := replace(l_onload_string, ''%COUNTRY_ID%'', apex_javascript.add_attribute(''id'',  l_country));',
'    l_onload_string := replace(l_onload_string, ''%COUNTRY_FORM%'', apex_javascript.add_attribute(''form'',  CASE WHEN l_country_long = ''Y'' THEN ''long_name'' ELSE ''short_name'' END));',
'    l_onload_string := replace(l_onload_string, ''%LAT_ID%'', apex_javascript.add_attribute(''id'',  l_latitude));',
'    l_onload_string := replace(l_onload_string, ''%LNG_ID%'', apex_javascript.add_attribute(''id'',  l_longitude));',
'    l_onload_string := replace(l_onload_string, ''%ACTION%'', apex_javascript.add_attribute(''action'',  l_action));',
'    l_onload_string := replace(l_onload_string, ''%TYPE%'', apex_javascript.add_attribute(''locationType'',  l_location_type));',
'    l_onload_string := replace(l_onload_string, ''%COMPONENT_TYPE%'', apex_javascript.add_attribute(''componentType'',  l_component_type));',
'',
'    apex_javascript.add_inline_code(p_code => l_onload_string);',
'',
'    p_result.is_navigable := true;',
'',
'end render_autocomplete;'))
,p_api_version=>2
,p_render_function=>'render_autocomplete'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:SOURCE:ELEMENT:WIDTH:ENCRYPT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>5
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137888905158417223)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Google Maps API Key'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_help_text=>'Enter your Google Maps API key here. You can get one from : https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete-addressform'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137890457692422129)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Action'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'If left null, you may only select a Google Place Address.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137890924681424105)
,p_plugin_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_display_sequence=>10
,p_display_value=>'Split into items and return JSON'
,p_return_value=>'SPLIT'
,p_help_text=>'Will split the address returned to be stored into multiple page items such as Street, City, State, Zip, etc.. As well as return the JSON if needed. The JSON data can be retrieved with the place_changed custom dynamic action event.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137891322528427830)
,p_plugin_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_display_sequence=>20
,p_display_value=>'Only return JSON'
,p_return_value=>'JSON'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Will just return the JSON contatining all the address components from the Google Place Address chosen.',
'The data can be retrieved with the place_changed custom dynamic action event.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137894468600497599)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Address Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the street address into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137896047363500462)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'City Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the city into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137897261437505124)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'State Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the state into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137898926052507700)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Zip Code Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the zip code into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137901312828513354)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Country Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the country into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137903917196518168)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Latitude Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the latitude into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137905335583520803)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Longitude Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137890457692422129)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SPLIT'
,p_help_text=>'Page item to return the longitude into.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137906949839525361)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Address Long Form'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137894468600497599)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_NULL'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Long form : 123 Testing Street',
'<br>',
'Short form: 123 Testing St.'))
,p_help_text=>'If set to ''Yes'', then the street address returned will be in long form. If set to ''No'', the street address returned will be in short form.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137908475842528777)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'State Long Form'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137897261437505124)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_NULL'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Long form : New York',
'<br>',
'Short form: NY'))
,p_help_text=>'If set to ''Yes'', then the state returned will be in long form. If set to ''No'', the state returned will be in short form.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137909660455532236)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Country Long Form'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(137901312828513354)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_NULL'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Long form : United States',
'<br>',
'Short form: US'))
,p_help_text=>'If set to ''Yes'', then the country returned will be in long form. If set to ''No'', the country returned will be in short form.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(137910899809534566)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Place Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_null_text=>'All'
,p_help_text=>'You may restrict results from a Place Autocomplete request to be of a certain type by passing a types parameter. The parameter specifies a type or a type collection, as listed in the supported types below. If nothing is specified, all types are retur'
||'ned. In general only a single type is allowed. The exception is that you can safely mix the geocode and establishment types, but note that this will have the same effect as specifying no types.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137912157318535930)
,p_plugin_attribute_id=>wwv_flow_api.id(137910899809534566)
,p_display_sequence=>10
,p_display_value=>'geocode'
,p_return_value=>'geocode'
,p_help_text=>'geocode instructs the Place Autocomplete service to return only geocoding results, rather than business results. Generally, you use this request to disambiguate results where the location specified may be indeterminate.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137912580503536970)
,p_plugin_attribute_id=>wwv_flow_api.id(137910899809534566)
,p_display_sequence=>20
,p_display_value=>'address'
,p_return_value=>'address'
,p_help_text=>'address instructs the Place Autocomplete service to return only geocoding results with a precise address. Generally, you use this request when you know the user will be looking for a fully specified address.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137912960990538173)
,p_plugin_attribute_id=>wwv_flow_api.id(137910899809534566)
,p_display_sequence=>30
,p_display_value=>'establishment'
,p_return_value=>'establishment'
,p_help_text=>'establishment instructs the Place Autocomplete service to return only business results.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137930424860539427)
,p_plugin_attribute_id=>wwv_flow_api.id(137910899809534566)
,p_display_sequence=>40
,p_display_value=>'(regions)'
,p_return_value=>'(regions)'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The (regions) type collection instructs the Places service to return any result matching the following types:',
'locality',
'sublocality',
'postal_code',
'country',
'administrative_area_level_1',
'administrative_area_level_2'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(137930902879541207)
,p_plugin_attribute_id=>wwv_flow_api.id(137910899809534566)
,p_display_sequence=>50
,p_display_value=>'(cities)'
,p_return_value=>'(cities)'
,p_help_text=>'The (cities) type collection instructs the Places service to return results that match locality or administrative_area_level_3.'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A0D0A202A20496E73756D20536F6C7574696F6E7320476F6F676C6520506C616365732041646472657373204175746F636F6D706C65746520666F7220415045580D0A202A20506C75672D696E20547970653A204974656D0D0A202A2053756D6D61';
wwv_flow_api.g_varchar2_table(2) := '72793A20506C7567696E20746F206175746F636F6D706C6574652061206C6F636174696F6E20616E642072657475726E20746865206164647265737320696E746F207365706172617465206669656C64732C2061732077656C6C2061732072657475726E';
wwv_flow_api.g_varchar2_table(3) := '2061646472657373204A534F4E20646174610D0A202A0D0A202A0D0A202A2056657273696F6E3A0D0A202A2020312E302E303A20496E697469616C0D0A202A0D0A202A205E5E5E20436F6E7461637420696E666F726D6174696F6E205E5E5E0D0A202A20';
wwv_flow_api.g_varchar2_table(4) := '446576656C6F70656420627920496E73756D20536F6C7574696F6E730D0A202A20687474703A2F2F7777772E696E73756D2E63610D0A202A206E6665726E30303240706C6174747362757267682E6564750D0A202A0D0A202A205E5E5E204C6963656E73';
wwv_flow_api.g_varchar2_table(5) := '65205E5E5E0D0A202A204C6963656E73656420556E6465723A20546865204D4954204C6963656E736520284D495429202D20687474703A2F2F7777772E6F70656E736F757263652E6F72672F6C6963656E7365732F67706C2D332E302E68746D6C0D0A20';
wwv_flow_api.g_varchar2_table(6) := '2A0D0A202A2040617574686F72204E65696C204665726E616E64657A202D20687474703A2F2F7777772E6E65696C6665726E616E64657A2E636F6D0D0A202A2F0D0A0D0A0D0A2F2F55534520617065782E64656275670D0A0D0A242E7769646765742827';
wwv_flow_api.g_varchar2_table(7) := '75692E706C616365734175746F636F6D706C657465272C207B0D0A20202F2F2044656661756C74206F7074696F6E730D0A20206F7074696F6E733A207B0D0A20202020706167654974656D733A207B0D0A2020202020206175746F436F6D706C6574653A';
wwv_flow_api.g_varchar2_table(8) := '207B0D0A202020202020202069643A2027270D0A2020202020207D2C0D0A202020202020726F7574653A207B0D0A202020202020202069643A2027272C0D0A2020202020202020666F726D3A2027270D0A2020202020207D2C0D0A2020202020206C6F63';
wwv_flow_api.g_varchar2_table(9) := '616C6974793A207B0D0A202020202020202069643A2027272C0D0A2020202020202020666F726D3A2027270D0A2020202020207D2C0D0A20202020202061646D696E6973747261746976655F617265615F6C6576656C5F313A207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(10) := '2069643A2027272C0D0A2020202020202020666F726D3A2027270D0A2020202020207D2C0D0A202020202020706F7374616C5F636F64653A207B0D0A202020202020202069643A2027272C0D0A2020202020202020666F726D3A2027270D0A2020202020';
wwv_flow_api.g_varchar2_table(11) := '207D2C0D0A202020202020636F756E7472793A207B0D0A202020202020202069643A2027272C0D0A2020202020202020666F726D3A2027270D0A2020202020207D0D0A202020207D2C0D0A20202020616374696F6E3A2027272C0D0A202020206C6F6361';
wwv_flow_api.g_varchar2_table(12) := '74696F6E547970653A2027272C0D0A20202020636F6D706F6E656E74547970653A2027270D0A20207D2C0D0A0D0A0D0A20202F2A2A0D0A2020202A205365742070726976617465207769646765742076617261626C65732E0D0A2020202A2F0D0A20205F';
wwv_flow_api.g_varchar2_table(13) := '736574576964676574566172733A2066756E6374696F6E2829207B0D0A2020202076617220756977203D20746869733B0D0A0D0A202020207569772E5F73636F7065203D202775692E706C616365734175746F636F6D706C657465273B202F2F466F7220';
wwv_flow_api.g_varchar2_table(14) := '646562756767696E670D0A0D0A202020207569772E5F76616C756573203D207B0D0A202020202020706C6163655F6A736F6E3A207B7D2C0D0A202020202020706C6163653A207B7D0D0A202020207D3B0D0A0D0A202020207569772E5F656C656D656E74';
wwv_flow_api.g_varchar2_table(15) := '73203D207B0D0A202020202020246175746F436F6D706C6574653A2024287569772E656C656D656E74290D0A202020207D3B0D0A202020207569772E5F636F6E7374616E7473203D207B0D0A202020202020676F6F676C654576656E743A2022706C6163';
wwv_flow_api.g_varchar2_table(16) := '655F6368616E676564222C0D0A202020202020617065784576656E743A2022706C6163655F6368616E676564222C0D0A20202020202073706C69743A202253504C4954222C0D0A202020202020706167654974656D3A20353132302C0D0A202020202020';
wwv_flow_api.g_varchar2_table(17) := '67726964436F6C756D6E3A20373934300D0A202020207D3B0D0A20207D2C202F2F5F736574576964676574566172730D0A0D0A20202F2A2A0D0A2020202A204372656174652066756E6374696F6E3A204F6E6C792063616C6C6564207468652066697273';
wwv_flow_api.g_varchar2_table(18) := '742074696D65207468652077696467657420697320617373696F636174656420746F20746865206F626A6563740D0A2020202A2057696C6C20696D706C696369746C792063616C6C20746865205F696E69742066756E6374696F6E2061667465720D0A20';
wwv_flow_api.g_varchar2_table(19) := '20202A2F0D0A20205F6372656174653A2066756E6374696F6E2829207B0D0A2020202076617220756977203D20746869733B0D0A0D0A202020207569772E5F7365745769646765745661727328293B202F2F20536574207661726961626C65732028646F';
wwv_flow_api.g_varchar2_table(20) := '6E2774206D6F646966792074686973290D0A0D0A2020202076617220636F6E736F6C6547726F75704E616D65203D207569772E5F73636F7065202B20275F637265617465273B0D0A202020202F2F20636F6E736F6C652E67726F7570436F6C6C61707365';
wwv_flow_api.g_varchar2_table(21) := '6428636F6E736F6C6547726F75704E616D65293B202F2F4E65656420746F2075736520617065782E64656275670D0A20202020617065782E64656275672E6C6F672827746869733A272C20756977293B0D0A0D0A202020202F2F20526567697374657220';
wwv_flow_api.g_varchar2_table(22) := '6175746F436F6D706C6574650D0A20202020766172206175746F636F6D706C657465203D206E657720676F6F676C652E6D6170732E706C616365732E4175746F636F6D706C657465280D0A2020202020202F2A2A204074797065207B2148544D4C496E70';
wwv_flow_api.g_varchar2_table(23) := '7574456C656D656E747D202A2F0D0A202020202020287569772E5F656C656D656E74732E246175746F436F6D706C6574652E676574283029292C207B0D0A202020202020202074797065733A205B7569772E6F7074696F6E732E6C6F636174696F6E5479';
wwv_flow_api.g_varchar2_table(24) := '7065203F207569772E6F7074696F6E732E6C6F636174696F6E54797065203A202267656F636F6465225D0D0A2020202020207D293B0D0A0D0A202020202F2F204269617320746865206175746F636F6D706C657465206F626A65637420746F2074686520';
wwv_flow_api.g_varchar2_table(25) := '7573657227732067656F67726170686963616C206C6F636174696F6E2C0D0A202020202F2F20617320737570706C696564206279207468652062726F77736572277320276E6176696761746F722E67656F6C6F636174696F6E27206F626A6563742E0D0A';
wwv_flow_api.g_varchar2_table(26) := '20202020696620286E6176696761746F722E67656F6C6F636174696F6E29207B0D0A2020202020206E6176696761746F722E67656F6C6F636174696F6E2E67657443757272656E74506F736974696F6E2866756E6374696F6E28706F736974696F6E2920';
wwv_flow_api.g_varchar2_table(27) := '7B0D0A20202020202020207661722067656F6C6F636174696F6E203D207B0D0A202020202020202020206C61743A20706F736974696F6E2E636F6F7264732E6C617469747564652C0D0A202020202020202020206C6E673A20706F736974696F6E2E636F';
wwv_flow_api.g_varchar2_table(28) := '6F7264732E6C6F6E6769747564650D0A20202020202020207D3B0D0A202020202020202076617220636972636C65203D206E657720676F6F676C652E6D6170732E436972636C65287B0D0A2020202020202020202063656E7465723A2067656F6C6F6361';
wwv_flow_api.g_varchar2_table(29) := '74696F6E2C0D0A202020202020202020207261646975733A20706F736974696F6E2E636F6F7264732E61636375726163790D0A20202020202020207D293B0D0A20202020202020206175746F636F6D706C6574652E736574426F756E647328636972636C';
wwv_flow_api.g_varchar2_table(30) := '652E676574426F756E64732829293B0D0A2020202020207D293B0D0A202020207D0D0A0D0A202020202F2F205768656E2074686520757365722073656C6563747320616E20616464726573732066726F6D207468652064726F70646F776E2C20706F7075';
wwv_flow_api.g_varchar2_table(31) := '6C6174652074686520616464726573730D0A202020202F2F206669656C647320696E2074686520666F726D2E0D0A0D0A202020206175746F636F6D706C6574652E6164644C697374656E6572287569772E5F636F6E7374616E74732E676F6F676C654576';
wwv_flow_api.g_varchar2_table(32) := '656E742C2066756E6374696F6E2829207B0D0A2020202020207569772E5F76616C7565732E706C616365203D206175746F636F6D706C6574652E676574506C61636528293B0D0A2020202020207569772E5F67656E65726174654A534F4E28293B0D0A0D';
wwv_flow_api.g_varchar2_table(33) := '0A2020202020202F2F205472696767657220706C6163655F6368616E67656420696E20415045580D0A2020202020207569772E5F656C656D656E74732E246175746F436F6D706C6574652E74726967676572287569772E5F636F6E7374616E74732E6170';
wwv_flow_api.g_varchar2_table(34) := '65784576656E742C207569772E5F76616C7565732E706C6163655F6A736F6E293B0D0A0D0A2020202020202F2F2053706C697420696E746F2070616765206974656D730D0A202020202020696620287569772E6F7074696F6E732E616374696F6E203D3D';
wwv_flow_api.g_varchar2_table(35) := '207569772E5F636F6E7374616E74732E73706C6974202626207569772E6F7074696F6E732E636F6D706F6E656E7454797065203D3D207569772E5F636F6E7374616E74732E706167654974656D29207B0D0A0D0A20202020202020202F2F20436C656172';
wwv_flow_api.g_varchar2_table(36) := '206F757420616C6C206974656D732065786365707420666F72207468652061646472657373206669656C640D0A2020202020202020666F722028766172206974656D20696E207569772E6F7074696F6E732E706167654974656D7329207B0D0A20202020';
wwv_flow_api.g_varchar2_table(37) := '2020202020206974656D203D3D20276175746F436F6D706C65746527203F206E756C6C203A202473287569772E6F7074696F6E732E706167654974656D735B6974656D5D2E69642C202727293B0D0A20202020202020207D0D0A0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(38) := '2F2F20536574206C6174697475646520616E64206C6F6E67697475646520696620746865792065786973740D0A20202020202020207569772E6F7074696F6E732E706167654974656D732E6C61742E6964203F202473287569772E6F7074696F6E732E70';
wwv_flow_api.g_varchar2_table(39) := '6167654974656D732E6C61742E69642C207569772E5F76616C7565732E706C6163652E67656F6D657472792E6C6F636174696F6E2E6C6174282929203A206E756C6C3B0D0A20202020202020207569772E6F7074696F6E732E706167654974656D732E6C';
wwv_flow_api.g_varchar2_table(40) := '6E672E6964203F202473287569772E6F7074696F6E732E706167654974656D732E6C6E672E69642C207569772E5F76616C7565732E706C6163652E67656F6D657472792E6C6F636174696F6E2E6C6E67282929203A206E756C6C3B0D0A0D0A2020202020';
wwv_flow_api.g_varchar2_table(41) := '202020666F7220287661722069203D20303B2069203C207569772E5F76616C7565732E706C6163652E616464726573735F636F6D706F6E656E74732E6C656E6774683B20692B2B29207B0D0A202020202020202020207661722061646472657373547970';
wwv_flow_api.g_varchar2_table(42) := '65203D207569772E5F76616C7565732E706C6163652E616464726573735F636F6D706F6E656E74735B695D2E74797065735B305D3B0D0A202020202020202020202F2F2047455420524944204F46204F55545445522049460D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(43) := '696620287569772E6F7074696F6E732E706167654974656D735B61646472657373547970655D29207B0D0A202020202020202020202020696620287569772E6F7074696F6E732E706167654974656D735B61646472657373547970655D2E696429207B0D';
wwv_flow_api.g_varchar2_table(44) := '0A20202020202020202020202020207661722076616C203D2027273B0D0A2020202020202020202020202020696620286164647265737354797065203D3D2027726F7574652729207B0D0A202020202020202020202020202020207569772E5F76616C75';
wwv_flow_api.g_varchar2_table(45) := '65732E706C6163652E616464726573735F636F6D706F6E656E74735B305D2E74797065735B305D203D3D20277374726565745F6E756D62657227203F2076616C203D207569772E5F76616C7565732E706C6163652E616464726573735F636F6D706F6E65';
wwv_flow_api.g_varchar2_table(46) := '6E74735B305D2E73686F72745F6E616D65202B20272027203A206E756C6C3B0D0A20202020202020202020202020207D0D0A202020202020202020202020202076616C202B3D207569772E5F76616C7565732E706C6163652E616464726573735F636F6D';
wwv_flow_api.g_varchar2_table(47) := '706F6E656E74735B695D5B7569772E6F7074696F6E732E706167654974656D735B61646472657373547970655D2E666F726D5D3B0D0A20202020202020202020202020202F2F205365742070616765206974656D2076616C75650D0A2020202020202020';
wwv_flow_api.g_varchar2_table(48) := '2020202020202473287569772E6F7074696F6E732E706167654974656D735B61646472657373547970655D2E69642C2076616C293B0D0A2020202020202020202020207D0D0A202020202020202020207D0D0A20202020202020207D202F2F20454E4420';
wwv_flow_api.g_varchar2_table(49) := '4C4F4F500D0A2020202020207D0D0A2020202020202F2F2053706C697420696E746F206772696420636F6C756D6E730D0A202020202020656C7365206966287569772E6F7074696F6E732E616374696F6E203D3D207569772E5F636F6E7374616E74732E';
wwv_flow_api.g_varchar2_table(50) := '73706C6974202626207569772E6F7074696F6E732E636F6D706F6E656E7454797065203D3D207569772E5F636F6E7374616E74732E67726964436F6C756D6E297B0D0A20202020202020202F2F204765742074686520706C6163652064657461696C7320';
wwv_flow_api.g_varchar2_table(51) := '66726F6D20746865206175746F636F6D706C657465206F626A6563742E0D0A202020202020202076617220706C616365203D207569772E5F76616C7565732E706C6163653B0D0A202020202020202076617220692C207265636F7264732C207265636F72';
wwv_flow_api.g_varchar2_table(52) := '642C206D6F64656C2C0D0A202020202020202076696577203D20617065782E726567696F6E28226175746F636F6D7022292E77696467657428292E696E74657261637469766547726964282267657443757272656E745669657722293B0D0A0D0A202020';
wwv_flow_api.g_varchar2_table(53) := '20202020206966202820766965772E737570706F7274732E656469742029207B202F2F206D616B652073757265207468697320697320746865206564697461626C6520766965770D0A2020202020202020202020206D6F64656C203D20766965772E6D6F';
wwv_flow_api.g_varchar2_table(54) := '64656C3B0D0A2020202020202020202020207265636F726473203D20766965772E67657453656C65637465645265636F72647328293B0D0A20202020202020202020202069662028207265636F7264732E6C656E677468203E20302029207B0D0A202020';
wwv_flow_api.g_varchar2_table(55) := '20202020202020202020202020666F7220282069203D20303B2069203C207265636F7264732E6C656E6774683B20692B2B2029207B0D0A20202020202020202020202020202020202020207265636F7264203D207265636F7264735B695D3B0D0A0D0A20';
wwv_flow_api.g_varchar2_table(56) := '20202020202020202020202020202020202020202F2F20436C656172206F757420616C6C206974656D732065786365707420666F72207468652061646472657373206669656C640D0A202020202020202020202020202020202020202020666F72202876';
wwv_flow_api.g_varchar2_table(57) := '6172206974656D20696E207569772E6F7074696F6E732E706167654974656D7329207B0D0A20202020202020202020202020202020202020202020207569772E6F7074696F6E732E706167654974656D735B6974656D5D2E6964203F206974656D203D3D';
wwv_flow_api.g_varchar2_table(58) := '20276175746F436F6D706C65746527203F206E756C6C203A206D6F64656C2E73657456616C7565287265636F72642C207569772E6F7074696F6E732E706167654974656D735B6974656D5D2E69642C20272729203A206E756C6C3B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(59) := '20202020202020202020202020207D0D0A0D0A2020202020202020202020202020202020202020202F2F20536574206C6174697475646520616E64206C6F6E67697475646520696620746865792065786973740D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(60) := '20202020207569772E6F7074696F6E732E706167654974656D732E6C61742E6964203F206D6F64656C2E73657456616C7565287265636F72642C207569772E6F7074696F6E732E706167654974656D732E6C61742E69642C20706C6163652E67656F6D65';
wwv_flow_api.g_varchar2_table(61) := '7472792E6C6F636174696F6E2E6C6174282929203A206E756C6C3B0D0A20202020202020202020202020202020202020207569772E6F7074696F6E732E706167654974656D732E6C6E672E6964203F206D6F64656C2E73657456616C7565287265636F72';
wwv_flow_api.g_varchar2_table(62) := '642C207569772E6F7074696F6E732E706167654974656D732E6C6E672E69642C20706C6163652E67656F6D657472792E6C6F636174696F6E2E6C6E67282929203A206E756C6C3B0D0A0D0A20202020202020202020202020202020202020202F2F204765';
wwv_flow_api.g_varchar2_table(63) := '7420616C6C206164647265737320636F6D706F6E656E74730D0A2020202020202020202020202020202020202020666F7220287661722069203D20303B2069203C207569772E5F76616C7565732E706C6163652E616464726573735F636F6D706F6E656E';
wwv_flow_api.g_varchar2_table(64) := '74732E6C656E6774683B20692B2B29207B0D0A20202020202020202020202020202020202020202020766172206164647265737354797065203D207569772E5F76616C7565732E706C6163652E616464726573735F636F6D706F6E656E74735B695D2E74';
wwv_flow_api.g_varchar2_table(65) := '797065735B305D3B0D0A202020202020202020202020202020202020202020202F2F2047455420524944204F46204F55545445522049460D0A20202020202020202020202020202020202020202020696620287569772E6F7074696F6E732E7061676549';
wwv_flow_api.g_varchar2_table(66) := '74656D735B61646472657373547970655D29207B0D0A202020202020202020202020202020202020202020202020696620287569772E6F7074696F6E732E706167654974656D735B61646472657373547970655D2E696429207B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(67) := '2020202020202020202020202020202020207661722076616C203D2027273B0D0A2020202020202020202020202020202020202020202020202020696620286164647265737354797065203D3D2027726F7574652729207B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(68) := '2020202020202020202020202020202020207569772E5F76616C7565732E706C6163652E616464726573735F636F6D706F6E656E74735B305D2E74797065735B305D203D3D20277374726565745F6E756D62657227203F2076616C203D207569772E5F76';
wwv_flow_api.g_varchar2_table(69) := '616C7565732E706C6163652E616464726573735F636F6D706F6E656E74735B305D2E73686F72745F6E616D65202B20272027203A206E756C6C3B0D0A20202020202020202020202020202020202020202020202020207D0D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(70) := '20202020202020202020202020202076616C202B3D207569772E5F76616C7565732E706C6163652E616464726573735F636F6D706F6E656E74735B695D5B7569772E6F7074696F6E732E706167654974656D735B61646472657373547970655D2E666F72';
wwv_flow_api.g_varchar2_table(71) := '6D5D3B0D0A20202020202020202020202020202020202020202020202020202F2F20536574206772696420636F6C756D6E2076616C75650D0A20202020202020202020202020202020202020202020202020206D6F64656C2E73657456616C7565287265';
wwv_flow_api.g_varchar2_table(72) := '636F72642C207569772E6F7074696F6E732E706167654974656D735B61646472657373547970655D2E69642C2076616C293B0D0A2020202020202020202020202020202020202020202020207D0D0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(73) := '207D0D0A20202020202020202020202020202020202020207D0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D0D0A20202020202020207D0D0A2020202020207D0D0A202020207D293B0D0A0D0A202020202F2F2063';
wwv_flow_api.g_varchar2_table(74) := '6F6E736F6C652E67726F7570456E6428636F6E736F6C6547726F75704E616D65293B202F2F204E65656420746F2066696E64206F757420746F2075736520617065782E64656275670D0A20207D2C202F2F5F6372656174650D0A0D0A20202F2A2A0D0A20';
wwv_flow_api.g_varchar2_table(75) := '20202A20496E69742066756E6374696F6E2E20546869732066756E6374696F6E2077696C6C2062652063616C6C656420656163682074696D652074686520776964676574206973207265666572656E6365642077697468206E6F20706172616D65746572';
wwv_flow_api.g_varchar2_table(76) := '730D0A2020202A2F0D0A20205F696E69743A2066756E6374696F6E28706C61636529207B0D0A2020202076617220756977203D20746869733B0A0D0A20202020617065782E64656275672E6C6F67287569772E5F73636F70652C20275F696E6974272C20';
wwv_flow_api.g_varchar2_table(77) := '756977293B0D0A20207D2C202F2F5F696E69740D0A0D0A0D0A20202F2A2A0D0A2020202A20536176657320706C6163655F6A736F6E20696E746F20696E7465726E616C205F76616C7565730D0A2020202A2F0D0A20205F67656E65726174654A534F4E3A';
wwv_flow_api.g_varchar2_table(78) := '2066756E6374696F6E2829207B0D0A2020202076617220756977203D20746869733B0D0A2020202076617220706C616365203D207569772E5F76616C7565732E706C6163653B0D0A0D0A202020207569772E5F76616C7565732E706C6163655F6A736F6E';
wwv_flow_api.g_varchar2_table(79) := '2E6C6174203D20706C6163652E67656F6D657472792E6C6F636174696F6E2E6C617428293B0D0A202020207569772E5F76616C7565732E706C6163655F6A736F6E2E6C6E67203D20706C6163652E67656F6D657472792E6C6F636174696F6E2E6C6E6728';
wwv_flow_api.g_varchar2_table(80) := '293B0D0A0D0A20202020666F7220287661722069203D20303B2069203C20706C6163652E616464726573735F636F6D706F6E656E74732E6C656E6774683B20692B2B29207B0D0A202020202020766172206164647265737354797065203D20706C616365';
wwv_flow_api.g_varchar2_table(81) := '2E616464726573735F636F6D706F6E656E74735B695D2E74797065735B305D3B0D0A2020202020207569772E5F76616C7565732E706C6163655F6A736F6E5B61646472657373547970655D203D20706C6163652E616464726573735F636F6D706F6E656E';
wwv_flow_api.g_varchar2_table(82) := '74735B695D2E6C6F6E675F6E616D653B0D0A202020207D0D0A0D0A20202020617065782E64656275672E6C6F67287569772E5F73636F70652C20275F67656E65726174654A534F4E272C20756977293B0D0A0D0A20207D2C202F2F5F67656E6572617465';
wwv_flow_api.g_varchar2_table(83) := '4A534F4E0D0A0D0A202064657374726F793A2066756E6374696F6E2829207B0D0A2020202076617220756977203D20746869733B0D0A20202020617065782E64656275672E6C6F67287569772E5F73636F70652C202764657374726F79272C2075697729';
wwv_flow_api.g_varchar2_table(84) := '3B0D0A202020202F2F20556E646F206175746F636F6D706C6574650D0A20202020242E5769646765742E70726F746F747970652E64657374726F792E6170706C79287569772C20617267756D656E7473293B202F2F2064656661756C742064657374726F';
wwv_flow_api.g_varchar2_table(85) := '790D0A20207D202F2F64657374726F790D0A0D0A7D293B202F2F75692E7769646765744E616D650D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(143399987013952216)
,p_plugin_id=>wwv_flow_api.id(137888084662405544)
,p_file_name=>'jquery.ui.autoComplete.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
