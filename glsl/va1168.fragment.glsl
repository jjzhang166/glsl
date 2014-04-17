#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphere(in vec3 p)
{
	float a;
	
	return (distance(vec3(0.0, 0.0, 0.0), p)-1.0);
}

// the real main function ;)
	float f(in vec3 p) {
	float ret;
	float smallest=0.0;
	float sum = -3.0;
	vec3 bplus = vec3(0.0, 0.0, 0.0);
		
	for (int u=0;u<1;u++) {
		bplus = vec3(float(-u)*2.0 + sin(time*2.0 + float(u)*2.0)*0.9,sin(time + float(u)*2.0)*0.25 , 0.0);
		sum += sphere(p+bplus)*1.0;
		if (sphere(p+bplus) < smallest) {
			smallest = (sphere(p+bplus));
		}			
	}
	ret = min(smallest, p.y+2.0);
	//ret = min(sum, p.y+2.0);
return ret;
}

vec3 n(in vec3 p) {
	float e=0.001;
vec3 n = vec3(f(p + vec3(e, 0, 0)) - f(p - vec3(e, 0, 0)), f(p + vec3(0, e, 0)) - f(p - vec3(0, e, 0)), f(p + vec3(0, 0, e)) - f(p - vec3(0, 0, e)));
n = normalize(n);
return n;
}

void main( void ) {

	//vec2 position = ( gl_FragCoord.xy / resolution.xy ); // arvot nollasta yhteen
	vec2 position = ( gl_FragCoord.xy / (resolution.yy)) ;
	
	float color = 0.1;
	
	vec3 camera_position, spos, light_pos;
	vec3 ro, rt;
	vec3 d, r, cam_point, normal;
	camera_position.xy = mouse;
	d = vec3(position.x-0.5, position.y-0.5, -1.0);
	d = normalize(d);
	float delta;
	int hit =0;
	
	light_pos = vec3(3.0, 5.0, 5.0);
	
	ro = camera_position;
	
	for(int i=0;i<250;i++)
	{
		if (hit==1) {
			break;	
		} else {
		
		
			rt=ro + vec3(0.0, 0.0, 7.0);
			delta = f(rt)+0.04;
			ro+=delta*d;
			
			
			if (f(rt)<0.0) {
				cam_point = normalize(rt + light_pos);
				normal = n(rt);
				color = dot(normal, cam_point) ;
				hit = 1;
			}
			
			if (rt.z < -10.0) { hit = 1; }
		
	}

	}
	
	
	//color = position.y;
	
	

	gl_FragColor = vec4( vec3( color, color*0.8, color*0.5 ), 1.0 );

}