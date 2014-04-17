#ifdef GL_ES
precision mediump float;
#endif

//tree! still cleaning up - lunchbreak over =(
//sphinx
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 uv;

float sdl(vec2 a, vec2 b);
float line(vec2 a, vec2 b, float w);
float sline(vec2 a, vec2 b, float w);
vec2 rotate(vec2 v, float ang);//< flotate
float branch(vec2 a, vec2 b, float bd, float bf, float r, float n, float w, float c);
//float leaf(vec2 a, vec2 b, float bd, float bf, float r, float n, float w, int c);
float hash(vec2 v);

float tree(vec2 a, vec2 b, float r, float n){
	float t;
	//bd = branch distance
	//bf = branch falloff
	//n = noise;
	//w = width;
	float w = .01;
	float h = 1.;
	float bf = .5;
	float bd = 1.;
	float s;
	
	t = sline(a+b, a, w);
	float br;
	for (int i = 0; i < 12; i++){	
		s = 1.-float(i)/13.;
		h = hash( s * vec2(b.y) ) * n;
		a += b * bd;
		b -= b * b.y;
		r += sin(time*.1)*.001+h * r;
		b = rotate(b, r);
		t = max(2.*t, sline(abs(a+b), a, w)*1.3);
		br += r+s+sin((time*0.01))*.1;	
		t = max(t, branch(a, b, bd, bf, br, .01, w * .65, s));	
		w *= .8;
		bd *= .98;
		bf -= h;
	}

	return t;
}

float branch(vec2 a, vec2 b, float bd, float bf, float r, float n, float w, float c){
	float v = 0.0;
	//bd = branch distance
	//bf = branch falloff
	//n = noise;
	//w = width;
	float h;
	float s;
	r = sin(5.*r-sin(c*h))+b.y;
	w *= .5*uv.y+.5;
	for (int i = 0; i < 6; i++){
		s = 1.-float(i)/6.;
		h = hash(vec2(c+s)) * n;
		a += b * bd;
		b *= .9 + b * s - b * bf;
		r += .01*sin(time*.92)+r*.5;
		r = .75*r+.5*r*c*s;
		b = rotate(b, .2*s*r+b.y);
		v += max(v, sline(a+b, a, w));
		
		if(i > 2){
			vec2 bb = b*c+b*sin(r+float(i))*.25;
			vec2 ba = a;
			float bbr = uv.x*sin(c)-cos(r+float(i));
			bb = rotate(bb, c-bbr);
			v = max(v, sline(ba+bb, ba, w * .65));
		}
		
		bd *= .999;
		bf -= bf*s;
		w *= .79;
		
		v *= .7;
	}
	
	return v;
}



void main( void ) {
	uv = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 a = vec2(.5, 0.);
	vec2 b = vec2(.0, .099);
	float r = (mouse.x-.5)*.1+cos(time*.01)*.01;
	float n = -.0025;//mouse.y;
	float v = tree(a, b, r, n);
	
	gl_FragColor = vec4(clamp(sin(1.-v)-v*.5*uv.y, -.25, 1.))*uv.y+.25*vec4(abs(sin(time)*.4)+6.*uv.x*.4*uv.y, .2 * uv.y, uv.x * .25 - uv.y, 1.);
}

float hash(vec2 v)
{
    return fract(sin(dot(v.xy+mouse.x, vec2(3.4352,6.4321))) );
}

vec2 rotate(vec2 v, float ang)
{
	mat2 m = mat2(cos(ang), sin(ang), -sin(ang), cos(ang));
	return m * v;
}


float line(vec2 a, vec2 b, float w){
	return step(sdl(a, b), w);
}

float sline(vec2 a, vec2 b, float w){
	return smoothstep(w, w*.3, sdl(a, b));
}

float sdl(vec2 a, vec2 b){
	float d;
	vec2 n, l;
	
	d = distance(a, b);
	n = normalize(b - a);
	l.x = max(abs(dot(uv - a, n.yx * vec2(-1.0, 1.0))), 0.0);
	l.y = max(abs(dot(uv - a, n) - d * 0.5) - d * 0.5, 0.0);
	
	return l.x+l.y;
}