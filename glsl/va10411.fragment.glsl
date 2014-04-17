// Playing around with Lissajous curves.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

float PI = 3.14159265358979323846264;
float a = 0.;
float b = 0.;
float c = 10.;

const int num = 180;

vec2 rose(float radian, float r) {
	float k = 2. + sin( a * radian ) / 2.;
	float tt = radian + sin( b * radian ) / c;
	float valueX = r * k * cos( tt );
	float valueY = -(r * k * sin( tt ));
	
	return vec2(valueX, valueY);
}  

void main( void ) {
	float sum = .0;
	float size = resolution.x / 80.0;
	
	for (int i = 0; i < num; ++i) {
        	vec2 position = resolution / 2.0;
		float t = (float(i) + time*.01)*sin(time*.001) * (sin(time*0.02));//*sin(time*.1)*.1);
		float d = float(i) * .1;
		float radius = length(position);  
	    
		a = (sin(time*.01)*3.5)*(sin(time*.01)*3.);
		// t += (atan(position.y,position.x)*.1);
		vec2 rose = rose(t, a);
        	position.x += rose.x*(size/3.);
		position.y += rose.y*(size/3.);
	    
		//float angle = degrees(atan(position.y,position.x)*.00001) ;
		//float amod = mod(angle+30.0*time-50.0*log(radius), 20.0) ;
	    
        	sum += size / length(gl_FragCoord.xy - position);
	}
	
	vec3 rgb = vec3(
		sum * .01, 
		sum * (sin(time*1.01)*1.1) * .006,
		sum * (cos(time*1.01)*1.1) * .006 * 1.6
	);
	
	
	gl_FragColor = vec4(rgb.x, rgb.y, rgb.z, 1);
}