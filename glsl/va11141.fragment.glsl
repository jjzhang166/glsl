#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
varying vec2 surfacePosition;

float PI = 3.14159;

float thickness = 0.001;


bool isInside(vec2 p, vec2 bl, vec2 tr) {
	if (p.x < bl.x || p.y < bl.y || p.x > tr.x || p.y > tr.y)
		return false;
	return true;
}

float drawLine(vec2 p, vec2 pa, vec2 pb ) {
	float d = distance(p, pa) + distance(p, pb) - distance(pa, pb);
	return 1.0-step(0.0001, d);
}

float drawRect(vec2 p, vec2 bl, vec2 tr) {
	float d;
	d += drawLine(p, bl, vec2(bl.x,tr.y)); // |.
	d += drawLine(p, bl, vec2(tr.x,bl.y)); // _
	d += drawLine(p, vec2(tr.x,bl.y), tr); // .|
	d += drawLine(p, vec2(bl.x,tr.y), tr); // -
	return d;
}
float drawRectFill(vec2 p, vec2 bl, vec2 tr) {
	if (isInside(p,bl,tr))
		return 1.0;
	return 0.0;
}
float acosAngle(vec2 v) {
	float x = v.x;
	float y = v.y;
	if (x == 0.0 && y == 0.0)
		return 0.0;
	float a = acos(x / sqrt(x * x + y * y)); 
	if (y < 0.0)
		a = 2.0 * PI - a;
	return 2.0 * PI - a;
}
vec3 getVectorColorRGBCircular(float angle, float intensity) {
	float r = ((sin(angle + PI / 2.0) + 0.5) * intensity);
	float g = ((sin(angle + PI / 2.0 - 1.0 / 3.0 * 2.0 * PI) + 0.5) * intensity);
	float b = ((sin(angle + PI / 2.0 - 2.0 / 3.0 * 2.0 * PI) + 0.5) * intensity);
	return vec3(r,g,b);
}
vec3 getVectorColorRGBCircular(vec2 p, vec2 cc, float intensity) {
	float angle = acosAngle(p-cc);
	vec3 col = getVectorColorRGBCircular(angle, intensity);
	return col;
}
vec3 drawRectColors(vec2 p, vec2 pa, vec2 pb) {
	vec2 bl = min(pa,pb);
	vec2 tr = max(pa,pb);
	if (!isInside(p,bl,tr))
		return vec3(0);
	vec2 sizehalf = abs(tr-bl) / 2.0;
	vec2 cc = bl+sizehalf;
	vec3 col = getVectorColorRGBCircular(p,cc,0.3);
	
	return col;
}

vec4 bb(vec2 pt) {
	return texture2D(backbuffer,pt);
}


void main( void ) {
	float aspectRatio = resolution.x/resolution.y;
	vec2 p = surfacePosition; //0,0 is in the screen center
	vec2 pt = p / vec2(aspectRatio,1) + vec2(0.5); //point for textures
	vec2 mouz = mouse - vec2(0.5);
	mouz *= 1.0;
	mouz.x *= aspectRatio;
	
	vec2 r2bl = vec2(0.1,0.1);
	vec2 r2tr = vec2(0.3,0.3);
	
	vec2 pObj = vec2(0.0,0.0);
	vec2 pObj2 = vec2(0.0,0.0);
	pObj += mouz;
	vec3 colPicked;
	vec3 col;
	float d;
	vec3 colPicker = drawRectColors(p, r2bl, r2tr); //tr
	col += colPicker;
	if (isInside(mouz, r2bl, r2tr))
		colPicked = getVectorColorRGBCircular(mouz,r2bl+(r2tr-r2bl)*0.5,0.3);
	d += drawRect(p, vec2(0.1,-0.1), vec2(0.3,-0.3)); //bl
	d += drawRect(p, vec2(-0.1,0.1), vec2(-0.3,0.3)); //tl
	d += drawRect(p, vec2(-0.1,-0.1), vec2(-0.3,-0.3)); //bl
	
	d += drawLine(p, vec2(0.0,0.0), pObj);
	bool drf = isInside(p, vec2(0.5,0.0), vec2(0.9, 0.4));
	col += (drf?1.0:0.0) * colPicked;
	
	gl_FragColor = vec4(d) + vec4(col,1) + bb(pt)*0.5;
}