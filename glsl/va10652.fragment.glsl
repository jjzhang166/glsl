#ifdef GL_ES
precision mediump float;
#endif

//tree! needs a big cleanup... very unstable... first pass!
//sphinx
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 uv;

float sdl(vec2 a, vec2 b);
float line(vec2 a, vec2 b, float w);
float sline(vec2 a, vec2 b, float w);
vec2 rotate(vec2 v, float ang);//< flotate
float branch(vec2 a, vec2 b, float bd, float bf, float r, float n, float w, int c);
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
		s = 1.+float(i);
		h = hash( s * vec2(b.y) ) * n;
		a += b * bd;
		b -= b * b.y;
		r += h * r;
		b = rotate(b, r);
		t = max(t, sline(abs(a+b), a, w));
		t = max(t, branch(a, b, bd, h*b.y*bd, sin(h*(time*0.001)+512.*h), h, w * .65, i));	
		w *= .8;
	}

	return t;
}

float branch(vec2 a, vec2 b, float bd, float bf, float r, float n, float w, int c){
	float v;
	//bd = branch distance
	//bf = branch falloff
	//n = noise;
	//w = width;
	float h;
	float s;
	r = .5-fract(r);
	w *= .5*uv.y+.5;
	for (int i = 0; i < 6; i++){
		s = float(i);
		h = hash( s * a + b ) * n;
		a += b * bd - bf * h;
		b -= b * .09;
		r += h;
		b = rotate(b, sin(cos(time)*.5+time*.92)*.01+r);
		
		v += max(v, sline(a+b, a, w));
		
		if(i > 2){
			b -= .5 * rotate(b, h+r);
			v = max(v, sline(a+b*.5, a, w * .59));
			b = rotate(b*.32, h-r);
			v = max(v, sline(a+b*9., a, w));
		}
		
		w *= .69;
	}
	
	return v;
}



void main( void ) {
	uv = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 a = vec2(.5, 0.);
	vec2 b = vec2(.0, .099);
	float r = .005;// mouse.x-.5;
	float n = -.0025;//mouse.y;
	float w;
	float v = tree(a, b, r, n);
	
	gl_FragColor = vec4(clamp(sin(1.-v)-v*.5*uv.y, -.25, 1.))*uv.y+.25*vec4(abs(sin(time)*.4)+6.*uv.x*.4*uv.y, .2 * uv.y, uv.x * .25 - uv.y, 1.);
}

float hash(vec2 v)
{
    return fract(sin(dot(v.xy, vec2(13.4352,56.4321))) * 57346.1234);
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