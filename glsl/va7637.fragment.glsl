#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float e = 0.510998928;

float semf(float Z, float N) {
	const float a_V = 15.67;
	const float a_O = 17.23;
	const float a_C = 0.714;
	const float a_S = 93.15;
	const float a_P = 11.2;
	float A = N + Z;
	return a_V * A - a_O * pow(A,2./3.) - a_C * Z * (Z-1.) * pow(A,-1./3.) - a_S * (N-Z)*(N-Z)/(4.*A) + a_P/sqrt(A)*(mod(N,2.)+mod(Z,2.)-1.);
}

float nDrip(float Z, float N) {
	return semf(Z,N-1.)-semf(Z,N);
}

float pDrip(float Z, float N) {
	return semf(Z-1.,N)-semf(Z,N);
}

float aDrip(float Z, float N) {
	return semf(Z-2.,N-2.)+28.295741*1.-semf(Z,N);
}

float beta(float Z, float N) {
	return max(semf(Z+1.,N-1.),semf(Z-1.,N+1.))-e-semf(Z,N);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy * vec2(180.,120.);
	
	float Z = floor(position.y);
	float N = floor(position.x);
	
	float r = pDrip(Z,N);
	float g = nDrip(Z,N);
	float b = aDrip(Z,N);
		
	gl_FragColor = vec4( min(max(vec3(r,g,b),0.),1.) + min(max(vec3(beta(Z,N)),0.),1.)*step(fract(dot(position,vec2(1.))),.5)*.5, 1.0 );

}