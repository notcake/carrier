function Algorithms.DepthFirstSearch (startingNode, edgeEnumeratorFactory, nodeSink)
	nodeSink (startingNode)
	
	local visitedNodes = {}
	local function DepthFirstSearch (startingNode, edgeEnumeratorFactory, nodeSink, visitedNodes)
		nodeSink (startingNode)
		visitedNodes [startingNode] = true
		
		for node in edgeEnumeratorFactory (startingNode) do
			if not visitedNodes [node] then
				DepthFirstSearch (node, edgeEnumeratorFactory, nodeSink, visitedNodes)
			end
		end
	end
	
	DepthFirstSearch (startingNode, edgeEnumeratorFactory, nodeSink, visitedNodes)
end