#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform sampler2D texture;
uniform vec2 mouse;
uniform float time;

struct cmat {
	vec2 a;
	vec2 b;
	vec2 c;
	vec2 d;
};

cmat inv(cmat M) {
	return cmat(M.d, -M.b, -M.c, M.a);
}


	
vec2 mult(vec2 a, vec2 b) { // complex prod a*b
	return vec2(a.x*b.x-a.y*b.y, a.x*b.y+a.y*b.x);
}

cmat mult(cmat A, cmat B) {
	return cmat(
		mult(A.a,B.a)+mult(A.b,B.c),
		mult(A.a,B.b)+mult(A.b,B.d),
		mult(A.c,B.a)+mult(A.d,B.c),
		mult(A.c,B.b)+mult(A.d,B.d)
	);
}

vec2 div(vec2 a, vec2 b) { //complex div a/b
	return 1./(b.x*b.x+b.y*b.y)*mult(a,vec2(b.x,-b.y));
}

vec2 moeb(cmat M, vec2 z) { //complex moebius transformation
	return div(mult(M.a,z)+M.b,mult(M.c,z)+M.d);
}

vec2 csqrt(vec2 z) { //complex square root
	float a = atan(z.y,z.x)/2.;
	float r = sqrt(length(z));
	return vec2(sqrt(r)*vec2(cos(a),sin(a)));
}

cmat M[4];
cmat T[2];
void main() {
	//return;
	M[0] = cmat(vec2(1,0), vec2(0,0), vec2(0,-2), vec2(1,0));
	M[1] = cmat(vec2(1,-1), vec2(1,0), vec2(1,0), vec2(1,1));
	M[2] = inv(M[0]);
	M[3] = inv(M[1]);
	
	
	//cmat R = cmat(vec2(1,0), vec2(mouse.x,0), vec2(mouse.y,0), vec2(mouse.x*mouse.y,0)); // R->R, det = 1
	cmat R = cmat(vec2(1.5-mouse.x,0.), vec2(mouse.y,0), vec2(0.,0), vec2(1,0)); //aff trans
	cmat C = cmat(vec2(1,0), vec2(0,-1), vec2(1,0), vec2(0,1)); //cayley H -> C
	T[0] = mult(C,mult(R,inv(C)));
	//T[0] = cmat(vec2(1.,0.), vec2(0,0), vec2(0,0), vec2(1,0)); //identity
	T[1] = inv(T[0]);
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	float ratio = resolution.y/resolution.x;
	
	//float A = 8.*mouse.y;
	float A = 4.;
	vec2 uv2 = A*(uv - vec2(0.5,0.5)); //verschiebung + skalierung
	
	vec2 z = vec2(uv2.x, uv2.y*ratio);
		
	
	vec2 res;
	vec4 color;
	
	res = vec2(0.);
	z = moeb(T[0],z);
	float F = 1.;
	if(z.y>0.001) {
		const int i = 2;
		res = moeb(M[i],z);
		//res = vec2(z.x, -z.y);	
		color = vec4(.9,0.8,0,1);
	}
	else if(distance(vec2(1,-1),z)<.995) {
		const int i = 3;
		res = moeb(M[i],z);
		color = vec4(1.,0,0,1);
	}
	else if(distance(vec2(0,-0.25),z)<.249) {
		const int i = 0;
		res = moeb(M[i],z);
		color = vec4(0.,1.,0,1);
	} 
	else if(distance(vec2(-1,-1),z)<.995) {
		const int i = 1;
		res = moeb(M[i],z);
		color = vec4(0.,0.,1,1);
	} else F = 0.;
	gl_FragColor = vec4(0);
	
	{
		res = moeb(T[1],res);
		
		float l = length(res);
		res /= A;
		vec2 tar = res;
		tar.y /= ratio;
		tar += vec2(0.5);
		
		if(0. < tar.x && tar.x < 1. && 0. < tar.y && tar.y < 1.){ //onscreen?
			gl_FragColor = texture2D( texture, tar );
			gl_FragColor += (0.1*color+vec4(.1+.1*cos(1.3*time),.05+.05*sin(1.4*time),.1,1))*exp(-l);
		}

	}
	gl_FragColor *= F;
	gl_FragColor.a = 1.;
}