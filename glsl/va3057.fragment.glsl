#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

void main( void ) {

	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;
	
	vec2 abspos = abs(pos);
	
    	float len =  length(pos);
	float invlen = 1.0-len;
	
	float sint = sin(time*0.5);
	float cost = cos(time*0.5);	
	float usint = sint*0.5+0.5;
	float ucost = cost*0.5+0.5;	

	float a = pos.x*sin(pos.x)*abspos.x;
	float b = pos.x*cos(unipos.x)*abspos.x;
	
	float c = pos.y*sin(pos.y)*pos.x*ucost;
	float d = pos.y*cos(pos.y)*usint;
		      
	float fa = atan(a,sin(c)-abspos.x);
	float fb = atan(b,cos(d)-abspos.y);

	float fc = fa * cos(a) *sin(c);
	float fd = fb * sin(b) *cos(d);

	
	
	float hue_a =  a+c;
	float hue_b = c+d;
	
	float hue = mix(hue_a, hue_b, fc);
	vec3 rgb = hsv2rgb(hue, fa, invlen);
	
	gl_FragColor = vec4( rgb, 1.0 );
}