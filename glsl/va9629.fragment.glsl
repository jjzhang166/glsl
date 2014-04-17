#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;





bool PointInTriangle(vec2 pt,vec2 p1,vec2 p2,vec2 p3) {
	
    float AB = (pt.y-p1.y)*(p2.x-p1.x) - (pt.x-p1.x)*(p2.y-p1.y);
    float CA = (pt.y-p3.y)*(p1.x-p3.x) - (pt.x-p3.x)*(p1.y-p3.y);
    float BC = (pt.y-p2.y)*(p3.x-p2.x) - (pt.x-p2.x)*(p3.y-p2.y);

    if (AB*BC>0.0 && BC*CA>0.0)
        return true;
    return false;   
}

vec4 hsv_to_rgb(float h, float s, float v, float a)
{
	float c = v * s;
	h = mod((h * 6.0), 6.0);
	float x = c * (1.0 - abs(mod(h, 2.0) - 1.0));
	vec4 color;
 
	if (0.0 <= h && h < 1.0) {
		color = vec4(c, x, 0.0, a);
	} else if (1.0 <= h && h < 2.0) {
		color = vec4(x, c, 0.0, a);
	} else if (2.0 <= h && h < 3.0) {
		color = vec4(0.0, c, x, a);
	} else if (3.0 <= h && h < 4.0) {
		color = vec4(0.0, x, c, a);
	} else if (4.0 <= h && h < 5.0) {
		color = vec4(x, 0.0, c, a);
	} else if (5.0 <= h && h < 6.0) {
		color = vec4(c, 0.0, x, a);
	} else {
		color = vec4(0.0, 0.0, 0.0, a);
	}
 
	color.rgb += v - c;
 
	return color;
}

vec4 drawLSDTrip(float circleRadius,float extrusion,int pointsOnCircle) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	const float PI = 3.14;

	vec2 circlePosition = vec2(0.5,0.5);
	circlePosition.x += sin(time / 10.0) / 5.0;
	circlePosition.y += cos(time / 10.0) / 5.0;
	
	float aspectCorrection = resolution.y / resolution.x;
	vec2 prevP = vec2(circlePosition.x + cos(time / 3.0) * circleRadius * aspectCorrection,sin(time / 3.0) * circleRadius  + circlePosition.y);
	
	vec4 color = vec4(0,0,0,0);
	
	float coef = 0.8;
	
	for (int i = 1; i <= 128; ++i) {
		
		if (i > pointsOnCircle) {
			break;
		}
		
		
		
		float angle = 2.0 * PI * float(i) / float(pointsOnCircle) + time / 3.0;
		
		vec2 p = vec2(circlePosition.x + aspectCorrection * circleRadius * cos(angle),
			      circlePosition.y + circleRadius * sin(angle));	
		
		
		float midAngle = angle - PI / float(pointsOnCircle);
		
		coef *= -1.0;
		
		midAngle += coef * sin(time * 0.2 / sqrt(circleRadius) + extrusion);
		
		vec2 extrudedPoint = vec2(circlePosition.x + aspectCorrection * extrusion * cos(midAngle),
					 circlePosition.y + extrusion * sin(midAngle));
		
		
		if (PointInTriangle(position,p,prevP,extrudedPoint)) {
			color = hsv_to_rgb(midAngle,1.0,clamp(abs(cos(time * circleRadius)),0.4,5.0),1.0);
		}
		
		prevP = p;	
	}
	return color;
}

void main( void ) {


	
	vec4 color = drawLSDTrip(0.3,0.4,16);
	if (color.w == 0.0) {
		color = drawLSDTrip(0.1,0.2,16);	
	}
	if (color.w == 0.0) {
		color = drawLSDTrip(0.2,0.3,16);	
	}

	if (color.w == 0.0) {
		color = drawLSDTrip(0.05,0.1,8);	
	}
		if (color.w == 0.0) {
		color = drawLSDTrip(0.01,0.05,8);	
	}
	
		if (color.w == 0.0) {
		color = drawLSDTrip(0.4,0.5,20);	
	}
	color.w = 0.0;
	
	gl_FragColor = color;

}