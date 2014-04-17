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
    vec2 dir = normalize(center-position) * cos(time);
    float dist = distance(position,center);
    float fov = 4.0;
    vec2 flower = (tan(dir/dist))/fov;

    vec3 normalColor = vec3(flower + position,0.5);
	
    gl_FragColor = vec4( normalColor, 1.0 );
	
}