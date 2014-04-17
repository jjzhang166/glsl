//                                                                 in progress...

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 q;
uniform vec2 surfaceSize;
varying vec2 surfacePosition;
	
vec3 rand3( vec2 seed ) {
	float t = sin(seed.x+seed.y*1e3);
	return vec3(fract(t*1e4), fract(t*1e6), fract(t*1e5));
}



struct circ
{
	vec2 centerCoords;
	float r;
	vec3 color ;
};

void drawCirc( circ c, inout vec3 col)	
{
	if ( length( q - c.centerCoords) < c.r) 
		//col = c.color;
		col += c.color;
		//col = mix( c.color, vec3(1.0) , col );
		
}

struct rect
{
	//vec2 coords;
	vec2 dimentions;
	vec3 color ;
	mat3 transform;
};
	
void m_translate( inout mat3 m, vec2 delta)
{
	m[2][0] -= delta.x; // x
	m[2][1]	-= delta.y; // y
}

void m_rotate( inout mat3 _m, float alpha )
{
	mat3 m;
	m[0][0] = cos( alpha );
	m[0][1] = -sin( alpha );
	m[1][0] = sin( alpha );
	m[1][1] = cos( alpha ) ;
	_m *= m;
}

void drawRect( rect r, inout vec3 col )
{
	vec2 q_ = (r.transform * vec3(q, 1.0)).xy;
	bool inside = 
		//step( origine , q_) == vec2(1.0) && 1.0 - step( farCorner, q_ ) == vec2(1.0);
		all( bvec4 (greaterThan(q_, vec2(0.0) ), lessThan( q_,  r.dimentions)));
		//( r.coords.x < q.x && q.x < r.coords + r.dimentions.x) &&
		//	( r.coords.y < q.y && q.y < r.coords + r.dimentions.y);
	
	if ( inside ) col += r.color; 
}
	
void main( void ) {

	q = gl_FragCoord.xy / resolution.xy;
	
	circ a,b;
	rect r;
	vec3 col;
	
	a.r = 0.1;
	a.centerCoords = surfacePosition;//vec2(0.15);
	a.color = vec3(1.0, 0.0, 0.0);
	
	b.r = 0.15;
	b.centerCoords = vec2(0.25);
	b.color = vec3(0.0, 0.0, 1.0);
	
	
	
	
	//r.coords = vec2(0.5);
	r.dimentions = vec2(0.15);
	r.color = vec3(0.0, 1.0, 0.0);
	r.transform = mat3(1.0);

	m_translate( r.transform, vec2(0.50, 0.4) );
	m_rotate( r.transform , time);
	
	const int n = 2;
	rect _rects[n];
	for(int i=0; i < n ; i++)
	{
		_rects[i].dimentions = vec2(0.15);
		_rects[i].color = rand3( vec2(i));
		_rects[i].transform = mat3(1.0);
		m_translate( _rects[i].transform, _rects[i].color.xy );
		m_rotate( _rects[i].transform ,   time * (_rects[i].color.x - 0.5));
		drawRect( _rects[i], col );
	}
	
	drawCirc( a, col );
	drawCirc( b, col );
	drawRect( r, col );
	
	
	//float f = ()?:;
	
	gl_FragColor = vec4(col , 1.0);
}