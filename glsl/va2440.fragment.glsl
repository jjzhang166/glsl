#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float map(vec3 p){
	return sqrt(p.x*p.x+p.y*p.y+p.z*p.z)-.5;
}

float intersect(in vec3 ro, in vec3 rd){
	
	for(float t = .2; t < 6.; t += .01){
		float h = map(ro+rd*t);
		if(h < .001) return t;
	}
	return 0.;
}



void main( void ) {

 	vec2 position = ( gl_FragCoord.xy / resolution.xy );
 	vec2 ratio = vec2(resolution.x/resolution.y,1.);
 
	 vec3 color = vec3(0.);

 	vec3 ro = vec3(0,0,0); // Punto di partenza
 	vec3 rd = normalize(vec3(-1.+2.*position,-1.)); // Direzione del raggio
 	
	float t = intersect(ro,rd);
	
	if(t > .2){
		color = vec3(1.);	
	}
	
 
 gl_FragColor = vec4( color, 1.0 );

}