
#ifdef GL_ES
precision mediump float; 
#endif

/*  // TinyGLSLFont experiment http://glsl.heroku.com/e#9762.7 @danbri  
    // Locations in 3x7 font grid, inspired by http://www.claudiocc.com/the-1k-notebook-part-i/ - trying the simplest font here
ABC // a:GIOMJL b:AMOIG c:IGMO d:COMGI e:OMGILJ f:CBN g:OMGIUS h:AMGIO i:GHN" j:GHTS k:AMIKO l:BN m:MGHNHIO n:MGIO
DEF // o:GIOMG p:SGIOM q:UIGMO r:MGI s:IGJLOM t:BNO u:GMOI v:GJNLI w:GMNHNOI x:GOKMI y:GMOIUS z:GIMO
GHI // 
JKL //  
MNO //   Q: What would an interesting API look like? Is code-gen needed? Is this slow?
PQR //      Todo: add numerals
STY */   
// some defaults
#define font_size 35. 
#define font_spacing .035

#define A_ vec2(0.,0.)
#define B_ vec2(1.,0.)
#define C_ vec2(2.,0.)

#define D_ vec2(0.,1.)
#define E_ vec2(1.,1.)
#define F_ vec2(2.,1.)

#define G_ vec2(0.,2.)
#define H_ vec2(1.,2.)
#define I_ vec2(2.,2.)

#define J_ vec2(0.,3.)
#define K_ vec2(1.,3.)
#define L_ vec2(2.,3.)

#define M_ vec2(0.,4.)
#define N_ vec2(1.,4.)
#define O_ vec2(2.,4.)

#define P_ vec2(0.,5.)
#define Q_ vec2(1.,5.)
#define R_ vec2(1.,5.)

#define S_ vec2(0.,6.)
#define T_ vec2(1.,6.)
#define U_ vec2(1.,6.)

#define A(p) t(G_,I_,p) + t(I_,O_,p) + t(O_,M_, p) + t(M_,J_,p) + t(J_,L_,p) 
#define B(p) t(A_,M_,p) + t(M_,O_,p) + t(O_,I_, p) + t(I_,G_,p) 
#define C(p) t(I_,G_,p) + t(G_,M_,p) + t(M_,O_,p) 
#define D(p) t(C_,O_,p) + t(O_,M_,p) + t(M_,G_,p) + t(G_,I_,p)
#define E(p) t(O_,M_,p) + t(M_,G_,p) + t(G_,I_,p) + t(I_,L_,p) + t(L_,J_,p)
#define F(p) t(B_,A_,p) + t(A_,M_,p) + t(M_,G_,p) + t(G_,H_,p)
#define G(p) t(O_,M_,p) + t(M_,G_,p) + t(G_,I_,p) + t(I_,U_,p) + t(U_,S_,p)
#define H(p) t(A_,M_,p) + t(M_,G_,p) + t(G_,I_,p) + t(I_,O_,p) 
#define I(p) t(G_,H_,p) + t(H_,N_,p) 
#define J(p) t(G_,H_,p) + t(H_,T_,p) + t(T_,S_,p)
#define K(p) t(A_,M_,p) + t(M_,I_,p) + t(I_,K_,p) + t(K_,O_,p)
#define L(p) t(B_,N_,p)
#define M(p) t(M_,G_,p) + t(G_,H_,p) + t(H_,N_,p) + t(N_,H_,p) + t(H_,I_,p) + t(I_,O_,p)
#define N(p) t(M_,G_,p) + t(G_,I_,p) + t(I_,O_,p)
#define O(p) t(G_,I_,p) + t(I_,O_,p) + t(O_,M_, p) + t(M_,G_,p)
#define P(p) t(S_,G_,p) + t(G_,I_,p) + t(I_,O_,p) + t(O_,M_,p)
#define Q(p) t(U_,I_,p) + t(I_,G_,p) + t(G_,M_,p) + t(M_,O_,p)
#define R(p) t(M_,G_,p) + t(G_,I_,p)
#define S(p) t(I_,G_,p) + t(G_,J_,p) + t(J_,L_,p) + t(L_,O_,p) + t(O_,M_,p)
#define T(p) t(B_,N_,p) + t(N_,O_,p)
#define U(p) t(G_,M_,p) + t(M_,O_,p) + t(O_,I_,p) 
#define V(p) t(G_,J_,p) + t(J_,N_,p) + t(N_,L_,p) + t(L_,I_,p)
#define W(p) t(G_,M_,p) + t(M_,N_,p) + t(N_,H_,p) + t(H_,N_,p) + t(N_,O_,p) + t(O_,I_,p)
#define X(p) t(G_,O_,p) + t(O_,K_,p) + t(K_,M_,p) + t(M_,I_,p)
#define Y(p) t(G_,M_,p) + t(M_,O_,p) + t(O_,I_,p) + t(I_,U_,p) + t(U_,S_,p)
#define Z(p) t(G_,I_,p) + t(I_,M_,p) + t(M_,O_,p)

uniform float time;
uniform vec2 resolution;

float min_distance(vec2 v, vec2 w, vec2 p) {  // thanks http://glsl.heroku.com/e#6140.0	
  	float l2 = (v.x - w.x)*(v.x - w.x) + (v.y - w.y)*(v.y - w.y); //length_squared(v, w);  // i.e. |w-v|^2 
  	if (l2 == 0.0) { return distance(p, v); }
  	float t = dot(p - v, w - v) / l2;
  	if(t < 0.0) { return distance(p, v); } 
	else if (t > 1.0) { return distance(p, w); }
  	vec2 projection = v + t * (w - v);  
	return distance(p, projection);
}

float textColor(vec2 from, vec2 to, vec2 p) {
	p *= font_size;
	float inkNess = 0., nearLine, corner, strokeWidth = 0.05;
        nearLine = min_distance(from,to,p); // basic distance from segment, 
        inkNess += smoothstep(0., 1., 1.- 14.*(nearLine - strokeWidth)); // ugly still
        inkNess += smoothstep(0., 3.2, 1.- (nearLine  + 6. * strokeWidth)); // glow
	return inkNess;
}

vec2 grid(vec2 letterspace) { return ( vec2( (letterspace.x / 1.8) * .65 , 1. - ((letterspace.y / .45) * 1.55) ));}
float t(vec2 from, vec2 to, vec2 p) {  return textColor(grid(from), grid(to),p);  }

vec2 r(vec2 p, float r) { // to the right ...
  p.y -= .8;	
  p.x -= font_spacing * r;	
  return p;
}

void main(void) {
	float ink, ink2, ink3, ink4 = 0.;
	vec3 col = vec3(0.05,0.05,0.05);  // b/g 
	vec2 c = vec2(resolution.x/2.0, resolution.y/2.0);
	vec2 p = gl_FragCoord.xy/resolution.xy; // our pixel

        ink4 += A(r(p,1.)) + B(r(p,2.)) + C(r(p,3.)) ;
	ink3 += D(r(p,4.)) + E(r(p,5.)) + F(r(p,6.)) ;
	ink2 += G(r(p,7.)) + H(r(p,8.)) + I(r(p,9.)) + J(r(p,10.)) + K(r(p,11.)) ;
	ink2 += L(r(p,12.)) + M(r(p,13.)) + N(r(p,14.)) + O(r(p,15.)) + P(r(p,16.)) + Q(r(p,17.)) + R(r(p,18.)) + S(r(p,19.)) + T(r(p,20.));
        ink += U(r(p,21.)) + V(r(p,22.)) + W(r(p,23.)) + X(r(p,24.)) + Y(r(p,25.)) + Z(r(p,26.)) ;
	
        col += vec3(ink,0.,0.);  
	// blend between zigzag FGQOKF in green, and 'e' (OMGILJ) in red
	col += mix( vec3(ink,cos(time/2.) * ink,0.), vec3(0., ink2, ink - ink2), (sin(.9 * time)));
	col += vec3(0., 0., ink3 * (5.  * p.x));
	col += vec3(0., ink4, 0.0);

	// example background from http://glsl.heroku.com/e#9742.3
	
	vec2 v=(gl_FragCoord.xy-(resolution*0.5))/min(resolution.y,resolution.x)*10.0;
	float t=time * 0.4,r=2.0;
	for (int i=1;i<4;i++){
		float d=(3.14159265 / float(6))*(float(i)*14.0);
		r+=length(vec2(v.y,v.x))+1.21;
		v = vec2(v.x+cos(v.y+cos(r)+d)+cos(t),v.y-sin(v.x+cos(r)+d)+sin(t));
	}
        r = (sin(r*0.05)*0.5)+0.5;
	r = pow(r, 30.0);
	col += .2 * vec3(r,pow(max(r-0.75,0.0)*4.0,2.0),pow(max(r-1.875,0.1)*5.0,4.0) );
	
	
        gl_FragColor = vec4( col, 1.0 );
}
