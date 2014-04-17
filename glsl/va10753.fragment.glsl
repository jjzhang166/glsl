#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415927

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.1415927;
float r = 0.003;
float r2 = 0.1;
float speed = 5.0;
float tail = 0.15;
float resx = resolution.x;
float resy = resolution.y;
float aspect = resx/resy;
vec3 col =  vec3(1.0, 0.2, 0.2);
vec3 color ; 
vec2 center(float k) {
	vec2 cen = vec2(0, 0);	
	cen.x = mouse.x        + 0.015*cos(time*k);
	cen.y = mouse.y/aspect + 0.0125*sin(time*k);
	return cen;
}
vec2 blocker(float k) {
	vec2 cen = vec2(0, 0);
	cen.x = mouse.x	       + 1.15*cos(k*time+0.68);
	cen.y = mouse.y/aspect + 1.15*sin(k*time+0.68);
	return cen;
}

void main( void ) {
	
	vec3 red = vec3(1.0, 0.0, 0.0);
	vec3 green = vec3(0.0, 1.0, 0.0);
	vec3 blue = vec3(0.0, 0.0, 1.0);
	
	vec2 position = gl_FragCoord.xy / resolution.x ;		
	//vec2 position = vec2(mouse.x, mouse.y/aspect);
	vec2 c = center(speed);
	vec2 c2 = blocker(speed);
	vec2 dcm = vec2(c.x - mouse.x, c.y - mouse.y/aspect);
	
	float Xdcm = pow(dcm.x, 2.0);
	float Ydcm = pow(dcm.y, 2.0);
	float XYdcm = pow(Xdcm + Ydcm, 0.5);
	
	float d = distance(position , c);	
	float d2 = distance(position , c2);
	float dR = distance(position, vec2(mouse.x, mouse.y/aspect));
	
	
	if( d < r) {
		color = col;		
	}else if( XYdcm<=dR+r && XYdcm>=dR-r && (c.y > mouse.y/aspect) && (c.x > mouse.x)){
		color  = red * ( max ( 0.8 - min ( pow ( d - r  , tail ) , 0.9 ) , 0.0 ) );	
	}else if( XYdcm<=dR+r && XYdcm>=dR-r && (c.y < mouse.y/aspect) && (c.x > mouse.x)){
		color  = red * ( max ( 0.8 - min ( pow ( d - r , tail ) , 0.9 ) , 0.0 ) );
	}else if( XYdcm<=dR+r && XYdcm>=dR-r && (c.y > mouse.y/aspect) && (c.x < mouse.x)){
		color  = red * ( max ( 0.8 - min ( pow ( d - r , tail ) , 0.9 ) , 0.0 ) );
	}else if( XYdcm<=dR+r && XYdcm>=dR-r && (c.y < mouse.y/aspect) && (c.x < mouse.x)){
		color  = red * ( max ( 0.8 - min ( pow ( d - r , tail ) , 0.9 ) , 0.0 ) );			
	}else{
		color = vec3(0.0);
	}
	
	if (d2 < r2) {
		color = vec3(0.0);
		if (d < r) {
			color = col;
		}
	}

	gl_FragColor = vec4( color , 1.0 );

}