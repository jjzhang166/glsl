#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv(float h,float s,float v) { return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v; }
// see also http://www.i-freeware-download.com/web-colors/hex-rgb-hsv-Grey-cId-878.aspx 
// http://en.wikipedia.org/wiki/HSL_and_HSV 
// so how would http://www.tate.org.uk/art/images/work/T/T02/T02030_10.jpg be expressed? http://www.tate.org.uk/art/artworks/riley-deny-ii-t02030/text-catalogue-entry
// grey HSVs here sampled from Deny II:

void main( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) ;
	vec2 xy = vec2(pos * 100.);
	vec3 color = vec3(0.,0.,0. );
	color = mix(hsv(218./360., .24, .96), hsv(216./360., .39, .58), pos.x + pos.y + (.02 * sin(time* 5.)) );
		
	if ( (xy.x/5. - floor(xy.x/5.) < .2 ) && (xy.y/5. - floor(xy.y/5.) < .2 ))
	 {
		color = hsv(213./360., .21, .35);	
         }
	
	for (int i = 5; i< 15; i++) {
	  int xness = int(floor(xy.x));
	  if ( xness - i == 8 * int(sin(time) * 15.) ) { color *= vec3(.5); }	

		if ( xness == i * (int(5. * sin(time)))) { color.rbg = vec3(1.); }	
	}
	
	if (((pos.x*100.) - floor(pos.x*100.) ) < 0.06) { color = hsv(216./360., .29, .58); }
	if (pos.y < .01) { color.rgb = vec3(.2,.2, sin(time) ); }
	
	
	
	gl_FragColor = vec4( color.r, color.g, color.b, 1.0 );

}