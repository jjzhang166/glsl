#ifdef GL_ES
precision highp float;
#endif

uniform vec3 unResolution;
uniform float time;
uniform sampler2D tex0;
uniform sampler2D tex1;
uniform sampler2D fft;
uniform vec4 unPar;
uniform vec4 unPos;
uniform vec3 unBeatBassFFT;

float iSphere(in vec3 ro, in vec3 rd) {

	//esfera no centro: |xyz|^2 = r^2 ou seja <xyz,xyz> = r^2
	// xyz = ro + t*rd, entao |ro|^2 + t^2 + 2<ro,rd>t - r^2 = 0
	float r = 1.0;
	float b = 2.0 * dot(ro,rd);
	float c = dot(ro,ro) - r*r;
	float h = b*b - 4.0*c;
	if(h<0.0) return -1.0;
	float t = (-b -sqrt(h)) / 2.0;
	
	return t;	 
}

float intersect(in vec3 ro, in vec3 rd) {
	float t = iSphere(ro,rd);	
	return t;
}

void main( void ) {

	// pixel coordinates from 0 to 1
	vec2 uv = gl_FragCoord.xy/unResolution.xy;
	
	//raytracer com origem ro e direcção rd
	vec3 ro = vec3(0.0, 1.0, 4.0);
	vec3 rd = normalize( vec3( -1.0+ 2.0*uv , -1.0) );
	
	//interseção com a scena 3D
	float id = intersect(ro, rd);
	
	//preto por defeito
	vec3 col = vec3(0.0);
	if(id> 0.0) {
		//no caso do raio bater, fica branco
		col = vec3(1.0);
	}
			
	gl_FragColor = vec4(col,1.0);
}