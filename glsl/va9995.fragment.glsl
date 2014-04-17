
#ifdef GL_ES
precision mediump float;
#endif

/*  // TinyGLSLFont experiment http://glsl.heroku.com/e#9725.10 @danbri  
    // Locations in 3x7 font grid, inspired by http://www.claudiocc.com/the-1k-notebook-part-i/ - trying the simplest font here
ABC // a:GIOMJL b:AMOIG c:IGMO d:COMGI e:OMGILJ f:CBN g:OMGIUS h:AMGIO i:GHN" j:GHTS k:AMIKO l:BN m:MGHNHIO n:MGIO
DEF // o:GIOMG p:SGIOM q:UIGMO r:MGI s:IGJLOM t:BNO u:GMOI v:GJNLI w:GMNHNOI x:GOKMI y:GMOIUS z:GIMO
GHI // Issues:
JKL //  * DistToLine is the wrong function; we want to know if ink path between 'from' and 'to' touches 'p'; not lines into infinity.
MNO //
PQR //
*/

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

#define A(p) t(G_,I_,p) + t(I_,O_,p) + t(O_,M_, p) + t(M_,J_,p) + t(J_,L_,p) 
#define B(p) t(A_,M_,p) + t(M_,O_,p) + t(O_,I_, p) + t(I_,G_,p) 
#define C(p) t(I_,G_,p) + t(G_,M_,p) + t(M_,O_,p) 
#define D(p) t(C_,O_,p) + t(O_,M_,p) + t(M_,G_,p) + t(G_,I_,p)
#define E(p) t(O_,M_,p) + t(M_,G_,p) + t(G_,I_,p) + t(I_,L_,p) + t(L_,J_,p)
// etc.

// input values
uniform float time;
uniform vec2 resolution; // resolution of the window

float DistToLine(vec2 pt1, vec2 pt2, vec2 testPt) // wrong comparison
{
  vec2 lineDir = pt2 - pt1;
  vec2 perpDir = vec2(lineDir.y, -lineDir.x);
  vec2 dirToPt1 = pt1 - testPt;
  return abs(dot(normalize(perpDir), dirToPt1));
}

float sqr(float x) { return x * x; }
float dist2(vec2 v, vec2 w) { return sqr(v.x - w.x) + sqr(v.y - w.y); }
float distToSegmentSquared(vec2 v, vec2 w, vec2 p) {
  // Return minimum distance between line segment vw and point p
  float l2 = dist2(v, w);
  if (l2 == 0.) return dist2(p, v);
  float t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
  if (t < 0.) return dist2(p, v);
  if (t > 1.) return dist2(p, w);
  return dist2(p, vec2(v.x + t * (w.x - v.x),
                       v.y + t * (w.y - v.y)));
}
//function distToSegment(p, v, w) { return Math.sqrt(distToSegmentSquared(p, v, w)); }


// TODO: thinking lacking here:
float textColor(vec2 from, vec2 to, vec2 p) {
        // here we should do something smarter than draw short straight lines
	float redTest = 0.;
	float nearLine = distToSegmentSquared(from, to, p); // wrong function, as it extends the line infinitely
	if (nearLine < .001) { 
    redTest = smoothstep(.9,.0, 5. *  nearLine); 
  }
  return redTest;
}




vec2 grid(vec2 letterspace) { 
	letterspace += 1.;
	return vec2( (letterspace.x / 2.) * .45, 1. - ((letterspace.y / 5.) * .65) );
}

float t(vec2 from, vec2 to, vec2 p) {
	return textColor(grid(from), grid(to), p ); // adjust frame of reference 
}

void main(void) {
	
	float ink, ink2, ink3, ink4 = 0.;
	vec3 col = vec3(0.1,0.1,0.1);  // b/g 
	vec2 c = vec2(resolution.x/2.0, resolution.y/2.0);
	vec2 p = gl_FragCoord.xy/resolution.xy; // our pixel
	
	// if (p.x>abs(sin(time/2.)) && p.y<.1) { ink = 1.;} // sanity checks
	
  ink = A(p); // 'a'; score for being on GIOMJL ink path. Expanded w/ 'define' preprocessor directive.
 
	
	// a custom closed shape: F_:G_:Q:O:K:F
	ink2 += t(F_,G_, p);
	ink2 += t(G_,Q_, p);
	ink2 += t( vec2(2.,4.), vec2(1.,5.), p);         // now a 3rd, Q -> O, expanding the def ourselves:
	ink2 += t(O_,K_,p);
	ink2 += t(K_,F_,p);

	// 
  ink3 += E(p); // OMGILJ
	
  col += vec3(ink,0.,0.);  // red is proximity to letter A
  //	col += vec3(0., ink2, 0.0); 
  //	col += vec3(0., 0., ink3);
  //	col += vec3(0., ink4, 0.0);

  gl_FragColor = vec4( col, 1.0 );
}
