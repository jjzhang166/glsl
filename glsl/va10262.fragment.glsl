//rebb
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI=3.14159265358979323846;
		float speed=time*0.2975;
		float r = .1;
		float dtime = sin (time*.93)*.94;
		float c= 12.0+time;

		float sdSphere( vec3 p, float size)
		{
			return length(p)-1.2;
		}

		float opTwist( vec3 p )
			{
		float c = cos(20.0*p.y+dtime/20.0);
		float s = sin(20.0*p.y);
		mat2  m = mat2(c,-s,s,c);
		vec3  q = vec3(m*p.xz,p.y);
		return sdSphere(q,1.2);
		}

		float rm(vec3 origin, vec3 ray, float min_distance, float max_distance) {
		float distance_marched = min_distance;
		for (int i=0; i<250; i++) {
		
		float step_distance = opTwist(origin + ray*distance_marched);
		if (abs(step_distance) < 0.0001) {
			return distance_marched/(max_distance-min_distance);
		}
		distance_marched += step_distance;
		if (distance_marched > max_distance) {
			return -1.0;
		}
		}
		return -1.0;
		}

		vec3 render(vec2 q) {
		vec3 eye = vec3(0.0+sin(dtime/4.0), 0.0+dtime/10.0, -3.0 + dtime/ 10.0 );
		vec3 screen = vec3(q, -2.0+dtime/100.0);
		vec3 ray = normalize(screen - eye);
 
		float s = rm(eye, ray, 1.0, 4.0);
	
		vec3 col;
	
		if (s == -1.0) {
				col = vec3(.5+0.4*q.y *cos(3.0*q.x));

		} else {
		col = vec3(s*.5+0.4*q.y *cos(3.0*q.x));
		col.rg *= 1.1;
		
		}
	
		return col;
		}

		void main()
		{
		vec2 q = 2.0* (2.0*gl_FragCoord.xy - resolution.xy)/resolution.x;
		vec3 col = render(q);
		q.x=col.x;
		q.y=col.y;	
	   	
		
		gl_FragColor = vec4(col.xyz, 1.0);
		}