
#ifdef GL_ES
precision mediump float; 
#endif

/*  // TinyGLSLFont experiment http://glsl.heroku.com/e#9743.22 @danbri  
    // Locations in 3x7 font grid, inspired by http://www.claudiocc.com/the-1k-notebook-part-i/ - trying the simplest font here
ABC // a:GIOMJL b:AMOIG c:IGMO d:COMGI e:OMGILJ f:CBN g:OMGIUS h:AMGIO i:GHN" j:GHTS k:AMIKO l:BN m:MGHNHIO n:MGIO
DEF // o:GIOMG p:SGIOM q:UIGMO r:MGI s:IGJLOM t:BNO u:GMOI v:GJNLI w:GMNHNOI x:GOKMI y:GMOIUS z:GIMO
GHI // Issues: API so ugly it needs a js code-generator; feels really slow, is that the nois? memory use (too much code?)
JKL //  
MNO // or see http://glsl.heroku.com/e#9762.0 for version without noise
PQR //
STY */
// some defaults
#define font_size 35. 
#define font_spacing .03

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

// a:GIOMJL b:AMOIG c:IGMO d:COMGI e:OMGILJ f:CBN g:OMGIUS h:AMGIO i:GHN" j:GHTS k:AMIKO l:BN m:MGHNHIO n:MGIO
 // o:GIOMG p:SGIOM q:UIGMO r:MGI s:IGJLOM t:BNO u:GMOI v:GJNLI w:GMNHNOI x:GOKMI y:GMOIUS z:GIMO
// etc.
uniform float time;
uniform vec2 resolution;


// aside:
// noise, just because.
//
// GLSL textureless classic 2D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-08-22
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/ashima/webgl-noise
//

vec4 mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
  return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec2 fade(vec2 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

// Classic Perlin noise
float cnoise(vec2 P)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod289(Pi); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;  
  g01 *= norm.y;  
  g10 *= norm.z;  
  g11 *= norm.w;  

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

// Classic Perlin noise, periodic variant
float pnoise(vec2 P, vec2 rep)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, rep.xyxy); // To create noise with explicit period
  Pi = mod289(Pi);        // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;  
  g01 *= norm.y;  
  g10 *= norm.z;  
  g11 *= norm.w;  

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}
// https://github.com/ashima/webgl-noise/blob/master/src/classicnoise2D.glsl 


float minimum_distance(vec2 v, vec2 w, vec2 p) {	// Return minimum distance between line segment vw and point p
  	float l2 = (v.x - w.x)*(v.x - w.x) + (v.y - w.y)*(v.y - w.y); //length_squared(v, w);  // i.e. |w-v|^2 -  avoid a sqrt
  	if (l2 == 0.0) {
		return distance(p, v);   // v == w case
	}
	
	// Consider the line extending the segment, parameterized as v + t (w - v).
  	// We find projection of point p onto the line.  It falls where t = [(p-v) . (w-v)] / |w-v|^2
  	float t = dot(p - v, w - v) / l2;
  	if(t < 0.0) {
		// Beyond the 'v' end of the segment
		return distance(p, v);
	} else if (t > 1.0) {
		return distance(p, w);  // Beyond the 'w' end of the segment
	}
  	vec2 projection = v + t * (w - v);  // Projection falls on the segment
	return distance(p, projection);
}

float textColor(vec2 from, vec2 to, vec2 p) {
	p *= font_size;
	float inkNess = 0., nearLine, corner, strokeWidth = 0.05;
        nearLine = minimum_distance(from,to,p); // basic distance from segment, thanks http://glsl.heroku.com/e#6140.0
        //        if (nearLine < strokeWidth) { inkNess = 1.; } ; // brutishly jagged
        inkNess += smoothstep(0., 1., 1.- 14.*(nearLine - strokeWidth)); // ugly still
        inkNess += smoothstep(0., 2.5, 1.- (nearLine  + 5. * strokeWidth)); // glow
	return inkNess;
}

vec2 grid(vec2 letterspace) {
	return ( vec2( (letterspace.x / 1.8) * .65 , 1. - ((letterspace.y / .45) * 1.55) ));
}
float t(vec2 from, vec2 to, vec2 p) {
	float f1 =   cnoise(vec2( p.x * p.x * p.x / p.y, p.x + sin(time /10.) ));
	return textColor(grid(from - (.25 * f1)), grid(to - (.25 + (f1/sin(time)) * f1)), p - f1 * .11); // adjust frame of reference 
}

vec2 r(vec2 p, float r) { 
  p.y -= .7;	
  p.x -= font_spacing * r;	
  return p;
}

vec2 d(vec2 p, float r) { 
  p.y -= font_spacing * r;	
  return p;
}

void main(void) {
	
	float ink, ink2, ink3, ink4 = 0.;
	vec3 col = vec3(0.05,0.05,0.05);  // b/g 
	vec2 c = vec2(resolution.x/2.0, resolution.y/2.0);
	vec2 p = gl_FragCoord.xy/resolution.xy; // our pixel
	
	// if (p.x>abs(sin(time/2.)) && p.y<.1) { ink = 1.;} // sanity checks
	//      ink = A(p); // 'a'; score for being on GIOMJL ink path. Expanded w/ 'define' preprocessor 
	//  ink += A(scatterText(p)); // 'e';  	
	// a custom closed shape (in green) FGQOKF, 
/*	ink2 += t(F_,G_, p);
	ink2 += t(G_,Q_, p);
	ink2 += t( vec2(2.,4.), vec2(1.,5.), p);         // now a 3rd, Q -> O, expanding the def ourselves:
	ink2 += t(O_,K_,p);
	ink2 += t(K_,F_,p);*/ 
 
	// 
	
  //      ink3 += H((p - .1)) + E((p - .2)) + L((p - .3)) + L((p - .4)) + O((p - .5)); 

        ink4 += A(r(p,1.)) + B(r(p,2.)) + C(r(p,3.)) ;
	ink3 += D(r(p,4.)) + E(r(p,5.)) + F(r(p,6.)) ;
	ink2 += G(r(p,7.)) + H(r(p,8.)) + I(r(p,9.)) + J(r(p,10.)) + K(r(p,11.)) ;

	// hmm something wrong here:
	ink2 += L(r(p,12.)) + M(r(p,13.)) + N(r(p,14.)) + O(r(p,15.)) + P(r(p,16.)) + Q(r(p,17.)) + R(r(p,18.)) + S(r(p,19.)) + T(r(p,20.));
        ink += U(r(p,21.)) + V(r(p,22.)) + W(r(p,23.)) + X(r(p,24.)) + Y(r(p,25.)) + Z(r(p,26.)) ;
	
	// color the inks
        col += vec3(ink,0.,0.);  
	col += vec3(0., ink2, 0.0);

	// blend between zigzag FGQOKF in green, and 'e' (OMGILJ) in red
	//col += mix( vec3(ink,0.,0.), vec3(0., ink2, 0.0), (sin(1.2 * time)));
	
	col += vec3(0., 0., ink3);
	col += vec3(0., ink4, 0.0);

        gl_FragColor = vec4( col, 1.0 );
}
