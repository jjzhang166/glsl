#ifdef GL_ES
precision mediump float;
#endif
/*
   Author : Hugo Scott-Slade
*/
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float f ( float a ) {

	return sin(a);
	
}

float K ( float a ) {
	
	float c = 0.0;

	for( float b = 0.0; b < 4.0; b += 1.0 ) {
		
		c += sin(a);
		
	} 
	
	return c;
	
}

void main( void ) {

    vec2 position = ( gl_FragCoord.xy / resolution.xy );
    vec2 center = vec2(0.5);
    vec2 dir = normalize(center-position);
    float dist = distance(position,center);
    float fov = 4.0;
    vec2 flower = (tan(dir/dist))/fov;

    vec3 normalColor = vec3(flower ,0.5);
	vec3 light = vec3(abs(sin(time)),1.,abs(cos(time+10.)));
	vec3 diff=vec3(dot(normalColor,light),dot(normalColor,light),dot(normalColor,light));
	vec3 amb=vec3(0.1,0.6,0.95);
    gl_FragColor = vec4( amb+0.9*diff,1.0 );
	
}