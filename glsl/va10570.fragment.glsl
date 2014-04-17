#ifdef GL_ES
precision mediump float;
#endif

// by @rianflo

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	vec2 p0 = vec2(-0.9801362166181207, 0.7133320029824972);
	vec2 p1 = vec2(0.6841536369174719, 0.0452396422624588);
	vec2 p2 = vec2(-0.1876563378609717, -0.2995676286518574);
	vec2 p3 = vec2(0.4626036649569869, 0.2069109776057303);
	vec2 p4 = vec2(0.5863597164861858, -0.47225348791107535);
	vec2 p5 = vec2(-0.2134767766110599, 0.5314431264996529);
	vec2 p6 = vec2(-0.40354382060468197, 0.6179361962713301);
	vec2 p7 = vec2(0.8017559270374477, 0.4957537869922817);
	vec2 p8 = vec2(-0.6258918326348066, -0.19205209147185087);
	vec2 p9 = vec2(-0.6484965835697949, 0.12037607934325933);
	vec2 p10 = vec2(0.1817763289436698, -0.7319995686411858);
	vec2 p11 = vec2(0.03400439955294132, 0.015528503805398941);
	vec2 p12 = vec2(-0.8207575110718608, -0.20950394216924906);
	vec2 p13 = vec2(0.4620666257105768, -0.8298074207268655);
	vec2 p14 = vec2(0.7118636784143746, -0.18039523344486952);
	vec2 p15 = vec2(0.7459373427554965, -0.9192065331153572);
	vec2 p16 = vec2(-0.8379013403318822, -0.4257906102575362);
	vec2 p17 = vec2(0.6868163528852165, -0.5935090645216405);
	vec2 p18 = vec2(-0.7533727665431798, 0.34916585916653275);
	vec2 p19 = vec2(0.5584901617839932, -0.17079990822821856);
	vec2 p20 = vec2(-0.05607030261307955, -0.20109707489609718);
	vec2 p21 = vec2(-0.5292902691289783, -0.3160477024503052);
	vec2 p22 = vec2(0.958707966376096, 0.07811622228473425);
	vec2 p23 = vec2(-0.9669322278350592, -0.7668777015060186);
	vec2 p24 = vec2(-0.514001720584929, 0.21057891100645065);
	vec2 p25 = vec2(0.625888504087925, 0.24024034570902586);
	vec2 p26 = vec2(0.14085335237905383, -0.9223673334345222);
	vec2 p27 = vec2(0.9979954264126718, 0.019927598536014557);
	vec2 p28 = vec2(-0.6689602402038872, -0.18976282747462392);
	vec2 p29 = vec2(-0.9763824176043272, -0.27004000497981906);
	vec2 p30 = vec2(0.4638286428526044, -0.08488307567313313);
	vec2 p31 = vec2(0.2535161036066711, -0.5959352040663362);
	
	
	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
	vec2 m = (mouse * 2.0 - 1.0) * vec2(resolution.x / resolution.y, 1.0);

	float d = cos(length(m - p)*18.0+time);
	d = min(d, cos(length(p0 - p)*18.0+time));
	d = min(d, cos(length(p1 - p)*18.0+time));
	d = min(d, cos(length(p2 - p)*18.0+time));
	d = min(d, cos(length(p3 - p)*18.0+time));
	d = min(d, cos(length(p4 - p)*18.0+time));
	d = min(d, cos(length(p5 - p)*18.0+time));
	d = min(d, cos(length(p6 - p)*18.0+time));
	d = min(d, cos(length(p7 - p)*18.0+time));
	d = min(d, cos(length(p8 - p)*18.0+time));
	d = min(d, cos(length(p9 - p)*18.0+time));
	d = min(d, cos(length(p10 - p)*18.0+time));
	d = min(d, cos(length(p11 - p)*18.0+time));
	d = min(d, cos(length(p12 - p)*18.0+time));
	d = min(d, cos(length(p13 - p)*18.0+time));
	d = min(d, cos(length(p14 - p)*18.0+time));
	d = min(d, cos(length(p15 - p)*18.0+time));
	d = min(d, cos(length(p16 - p)*18.0+time));
	d = min(d, cos(length(p17 - p)*18.0+time));
	d = min(d, cos(length(p18 - p)*18.0+time));
	d = min(d, cos(length(p19 - p)*18.0+time));
	d = min(d, cos(length(p20 - p)*18.0+time));
	d = min(d, cos(length(p21 - p)*18.0+time));
	d = min(d, cos(length(p22 - p)*18.0+time));
	d = min(d, cos(length(p23 - p)*18.0+time));
	d = min(d, cos(length(p24 - p)*18.0+time));
	d = min(d, cos(length(p25 - p)*18.0+time));
	d = min(d, cos(length(p26 - p)*18.0+time));
	d = min(d, cos(length(p27 - p)*18.0+time));
	d = min(d, cos(length(p28 - p)*18.0+time));
	d = min(d, cos(length(p29 - p)*18.0+time));
	d = min(d, cos(length(p30 - p)*18.0+time));
	d = min(d, cos(length(p31 - p)*18.0+time));
	
	
	vec3 color = vec3((d+1.0)*128.0);
	gl_FragColor = vec4( color, 1.0 );

}