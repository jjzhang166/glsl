#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float cross2(vec2 v1, vec2 v2) {
	return (v1.x*v2.y) - (v1.y*v2.x);	
}

void main( void ) {
	
	const int NUM_VERTS = 6;
	const int LAST_VERT = NUM_VERTS - 1;
	
	vec2 v[NUM_VERTS];
	v[0] = vec2(400.0, 100.0);
	v[1] = vec2(1200.0, 200.0);
	v[2] = vec2(1500.0, 800.0);
	v[3] = vec2(800.0, 950.0);
	v[4] = vec2(300.0, 700.0);
	v[5] = vec2(800.0, 500.0);
	
	vec4 C[NUM_VERTS];
	C[0] = vec4(1.0, 0.0, 0.0, 1.0);
	C[1] = vec4(0.0, 1.0, 0.0, 1.0);
	C[2] = vec4(0.0, 0.0, 1.0, 1.0);
	C[3] = vec4(1.0, 0.0, 0.0, 1.0);
	C[4] = vec4(0.0, 1.0, 0.0, 1.0);
	C[5] = vec4(0.0, 0.0, 1.0, 1.0);
	
	vec2 F = gl_FragCoord.xy*3.;
	
	vec2 S[NUM_VERTS];
	float R[NUM_VERTS];
	for (int i = 0; i < NUM_VERTS; ++i) {
		S[i] = v[i] - F;
		R[i] = length(S[i]);
		if (R[i] <= 5.0) {
			gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);//C[i];
			//return;
		}
	}
	
	float A[NUM_VERTS];
	float D[NUM_VERTS];
	for (int i = 0; i < NUM_VERTS-1; ++i) {
		A[i] = cross2(S[i], S[i+1]);
		D[i] = dot(S[i], S[i+1]);
		
		if ((abs(A[i]) <= 400.0) && (D[i] < 0.0)) {
			gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0); //(R[i+1]*C[i] + R[i]*C[i+1]) / (R[i] + R[i+1]);
			return;
		}
	}
	
	A[LAST_VERT] = cross2(S[LAST_VERT], S[0]);
	D[LAST_VERT] = dot(S[LAST_VERT], S[0]);
	
	if ((abs(A[LAST_VERT]) <= 400.0) && (D[LAST_VERT] < 0.0)) {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0); //(R[0]*C[LAST_VERT] + R[LAST_VERT]*C[0]) / (R[LAST_VERT] + R[0]);
		return;
	}
	
	vec4 c = vec4(0.0, 0.0, 0.0, 1.0);
	float W = 0.0;
	
	// v1
	float w = 0.0;
	if (A[LAST_VERT] != 0.0) {
		w += (R[LAST_VERT] - D[LAST_VERT]/R[0]) / A[LAST_VERT];
	}
	if (A[0] != 0.0) {
		w += (R[1] - D[0]/R[0]) / A[0];
	}
	c += w*C[0];
	W += w;
	
	for (int i = 1; i < NUM_VERTS-1; ++i) {
		w = 0.0;
		if (A[i-1] != 0.0) {
			w += (R[i-1] - D[i-1]/R[i]) / A[i-1];
		}
		if (A[i] != 0.0) {
			w += (R[i+1] - D[i]/R[i]) / A[i];
		}
		c += w*C[i];
		W += w;
	}
	
	// last vertex
	w = 0.0;
	if (A[LAST_VERT-1] != 0.0) {
		w += (R[LAST_VERT-1] - D[LAST_VERT-1]/R[LAST_VERT]) / A[LAST_VERT-1];
	}
	if (A[LAST_VERT] != 0.0) {
		w += (R[0] - D[LAST_VERT]/R[LAST_VERT]) / A[LAST_VERT];
	}
	c += w*C[LAST_VERT];
	W += w;
	
	gl_FragColor = c/W;
}