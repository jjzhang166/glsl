#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 colour ;

float aspect = resolution.x/resolution.y;

vec2 circle( vec2 c ){
	c.x = 0.25*mod(time,4.0); //0.25+sin(c.x)*0.25;
	c.y = 0.25+cos(c.y)*0.25;
	return c;
}

vec2 circleLag (vec2 c){
	c.x = 0.25*mod(time,4.0)-0.03; //0.25+sin(c.x)*0.25;
	c.y = 0.25+cos(c.y)*0.25;
	return c;
}

void main( void ) {
	vec2 center = circle (vec2(time, time));		
	vec2 cenLag = circleLag (vec2(time, time));

	vec2 position = ( gl_FragCoord.xy / resolution.x );
	float d = distance(position, vec2(mouse.x, mouse.y/aspect));
	float d2 = distance(center, mouse);
	float d3 = distance(position, center);
	
	float l = distance(center, cenLag);
	
	if(d3>0.04){
		colour = vec3 (1.8, 1.4, 1.0) * ( max ( 0.8 - min ( pow ( l - d3  , 0.5 ) , 0.9 ) , 0.0 ) );			
	}else {
		colour = vec3 (1.0, 1.0, 1.0);
	}
	

	gl_FragColor = vec4(colour, 0.0);

}