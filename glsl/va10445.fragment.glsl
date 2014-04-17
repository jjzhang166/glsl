// Playing around with Lissajous curves.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;
float PI = 3.14159265358979323846264;
const int num = 200;


void main( void ) {
	float a = 0.;
	float b = 0.;
	float c = 10.;

	float sum = .0;
    	float size = resolution.x / 40.0;
	
    	for (int i = 0; i < num; ++i) {
        	vec2 position = resolution / 2.0;
		float t = (float(i)) / cos(time*.001)+(sin(time*.3)); 
	    
		a = 5.0 - (3.*sin(time*.21)) ; //.1+2.*((sin(time*.05)*1.2)+.1)*2.232;
		t += (atan(position.y,position.x));
	    
		float k = 2. + sin( a * t ) / 2.;
		float tt = t + sin( b * t ) / c;
		float radius = length(position);
		
		position.x += (a * k * cos( tt ) * size);
		position.y += (a * k * sin( tt ) * size);
	    
        	sum += size / length(gl_FragCoord.xy - position)-(radius*.0001);
	}
	
	sum *= .24711;
	
	vec3 rgb = vec3((sum * .03), sum * (cos(time*2.)*4.) * .01, sum * (sin(time*2.)*1.1) * .06);
	vec2 texPos = vec2(gl_FragCoord.xy/resolution);
	vec4 tex = .25+rgb.xyzx*step(1., texture2D(backbuffer, texPos));
	
	gl_FragColor = vec4(rgb.x+float(tex), rgb.y+float(tex), rgb.z+float(tex), 1);
}