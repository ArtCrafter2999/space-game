extends Node3D

@export var end_a : RopeEnd
@export var end_b : RopeEnd
@export var segment: PackedScene

func _ready() -> void:
	var prev_segment : RopeEnd = end_a
	var new_segment: RopeSegment = segment.instantiate() as RopeSegment
	var distance = end_a.global_position.distance_to(end_b.global_position);
	_add_new_segment(prev_segment, new_segment);
	prev_segment = new_segment
	var segment_amount = round(distance / new_segment.length);
	
	for i in (segment_amount-1):
		new_segment = segment.instantiate() as RopeSegment 
		_add_new_segment(prev_segment, new_segment);
		prev_segment = new_segment
	prev_segment.connect_to(end_b.body)
	end_b.joint.queue_free();

func _add_new_segment(prev_segment: RopeEnd, new_segment: RopeSegment):
	add_child(new_segment);
	new_segment.global_position = prev_segment.joint.global_position
	new_segment.look_at(end_b.global_position)
	prev_segment.connect_to(new_segment.body);


#Функціонал порваного провода хз чи потрібен

#var breaked = false;
#
#func _process(delta: float) -> void:
	#if breaked: return;
	#var segments = find_children("*", "RopeSegment", false, false) as Array[RopeSegment];
	#if segments.size() < 2: return;
	#var max_length = segments.reduce(func (acc, value): return acc + value.length, 0)
	#var distance = segments[0].position.distance_to(segments[segments.size()-1].position)
	#if distance > max_length * 2:
		#var index = randi_range(0, segments.size() -2)
		#for segment: Node3D in segments.slice(0, index):
			#segment.reparent(get_parent());
		#segments[index].joint.node_a = ""
		#segments[index].joint.node_b = ""
		#breaked = true;
