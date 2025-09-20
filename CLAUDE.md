# Claude's Guide to BMAD-METHOD™

## What is BMAD-METHOD?

BMAD-METHOD™ (Breakthrough Method of Agile AI-Driven Development) is a powerful natural language-driven AI Agent Framework that transforms software development and other domains through specialized AI agents. It provides foundations in Agentic Agile Driven Development, enabling transformation of any domain with specialized AI expertise: software development, entertainment, creative writing, business strategy to personal wellness.

## Core Philosophy

BMAD addresses the two biggest problems in AI-assisted development through two revolutionary innovations:

1. **Agentic Planning**: Dedicated agents (Analyst, PM, Architect) collaborate with you to create detailed, consistent PRDs and Architecture documents through advanced prompt engineering and human-in-the-loop refinement.

2. **Context-Engineered Development**: The Scrum Master agent transforms these detailed plans into hyper-detailed development stories that contain everything the Dev agent needs - full context, implementation details, and architectural guidance embedded directly in story files.

## Two-Phase Workflow

### Phase 1: Planning (Web-Based)
The Planning Phase operates entirely in the web environment and involves four core planning agents working in sequence to create comprehensive project documentation. This phase transforms initial project concepts into comprehensive, validated documentation ready for implementation.

### Phase 2: Development (IDE-Based)  
Once you have your PRD, Architecture, optional UX and Briefs - it's time to switch over to the IDE to shard your docs, and start implementing the actual code!

## Core Agents and Their Roles

### Planning Agents (Web-Based)

#### 1. **Analyst Agent (Mary)**
The analyst agent specializes in initial project discovery, market research, and strategic analysis. Mary creates the foundational project-brief.md document that informs all subsequent planning activities.

**Command**: `*analyst`
**Purpose**: Create comprehensive project brief through guided brainstorming, market research, and competitive analysis

#### 2. **PM Agent (John)** 
The pm agent transforms project briefs into detailed product requirements documents. John specializes in product strategy, feature prioritization, and stakeholder requirements gathering.

**Command**: `*pm` or `*agent pm`
**Purpose**: Generate comprehensive PRD from brief, define epics and initial story breakdown

#### 3. **Architect Agent (Winston)**
The architect agent creates comprehensive system architecture documents covering frontend, backend, and full-stack designs. Winston bridges business requirements with technical implementation strategies.

**Command**: `*agent architect`
**Purpose**: Design system architecture from PRD, create technical specifications and constraints

#### 4. **UX Expert Agent**
The ux-expert agent specializes in user experience design and frontend specifications.

**Command**: `*agent ux`
**Purpose**: Create Front End Specification and generate UI prompts (optional)

#### 5. **Product Owner Agent (PO)**
**Command**: `*agent po`
**Purpose**: Run master checklist to ensure document alignment, shard PRD into focused epic files, shard Architecture into component-specific docs

### Development Agents (IDE-Based)

#### 6. **Scrum Master Agent (SM)**
The Scrum Master (SM) agent reviews the sharded documents and drafts individual development stories. Each story is a self-contained unit of work, embedding context, implementation details, and architectural guidance.

**Command**: `*agent sm`
**Purpose**: Create detailed story from next epic, include full context and acceptance criteria

#### 7. **Dev Agent**
The Development (Dev) agent takes a drafted story file and generates the actual code and associated tests. The story file provides all the necessary context, minimizing the need for external lookups.

**Command**: `*agent dev`
**Purpose**: Implement story with architectural alignment, run all validations (tests, linting, security)

#### 8. **QA Agent**
A QA agent can review the generated code and tests against defined quality standards, refactor code, add more tests, and document any findings.

**Command**: `*agent qa`
**Purpose**: Review implementation, suggest improvements and optimizations

#### 9. **BMad Orchestrator**
This agent can do any task or command that all other agents can do, aside from actual story implementation. Additionally, this agent can help explain the BMad Method when on the web by accessing the knowledge base and explaining anything to you about the process.

**Command**: `#bmad-orchestrator`
**Purpose**: General-purpose agent for explanations and task management (Web UI only)

## Installation and Setup

### Quick Start Installation
```bash
# Install BMAD-METHOD in your project
npx bmad-method install

# OR for existing projects
git pull
npm run install:bmad
```

The installer will detect an existing installation and offer to upgrade automatically. This sets up agents, dependencies, templates, and sharding tools.

### Project Structure After Installation
```
your-project/
├── .bmad-core/
│   ├── agents/           # Agent definitions
│   ├── workflows/        # YAML workflow files
│   ├── templates/        # Document templates
│   ├── tasks/           # Task definitions
│   ├── data/            # Knowledge base and preferences
│   └── core-config.yaml # Configuration file
└── docs/
    ├── prd.md           # Product Requirements Document
    ├── architecture.md  # System Architecture
    └── stories/         # Development stories
```

## Step-by-Step Workflow

### Phase 1: Planning (Web UI)

Use the web UI with large context models (Gemini, Claude, or GPT-4) for cost-effectiveness during planning.

#### Step 1: Project Analysis
```
*analyst
I want to build a [description of your project]
```
**Output**: Comprehensive project brief (10-15 pages) with market analysis, user personas, competitive insights

#### Step 2: Requirements Definition
```
*agent pm
[Upload project brief]
Create a comprehensive PRD from this brief
```
**Output**: Detailed PRD with Functional Requirements, Non-Functional Requirements, Epics, and Stories

#### Step 3: UX Design (Optional)
```
*agent ux
[Upload PRD]
Create UX specifications for this product
```
**Output**: Front End Specification and UI prompts

#### Step 4: Architecture Design
```
*agent architect
[Upload PRD and optional UX specs]
Design the system architecture
```
**Output**: Comprehensive architecture document covering frontend, backend, and full-stack designs

#### Step 5: Validation and Sharding
```
*agent po
Run master checklist on all documents and shard for development
```
**Output**: Validated and sharded documents ready for development

### Phase 2: Development (IDE)

When to move to the IDE: Once you have your PRD, Architecture, optional UX and Briefs - it's time to switch over to the IDE to shard your docs, and start implementing the actual code!

#### Step 6: Story Creation
```
*agent sm
Create the next development story from [epic file]
```
**Output**: Detailed story file with full context and acceptance criteria

#### Step 7: Implementation
```
*agent dev
Implement story [story file name]
```
**Output**: Code implementation with tests and documentation

#### Step 8: Quality Assurance
```
*agent qa
Review the implementation of [story/module]
```
**Output**: Code review, improvements, and optimizations

## Key Configuration Files

### core-config.yaml
The bmad-core/core-config.yaml file is a critical config that enables BMad to work seamlessly with differing project structures. Currently the most important is the devLoadAlwaysFiles list section.

```yaml
devLoadAlwaysFiles:
  - docs/architecture/coding-standards.md
  - docs/architecture/tech-stack.md
  - docs/architecture/project-structure.md
```

### Technical Preferences
Define your preferences in .bmad-core/data/technical-preferences.md. Include preferred frameworks, stack, naming rules, etc.

## IDE Integration

### Cursor Integration
File Format: Custom .cursor-rules and agent definitions. Features: Advanced code completion with persona context, multi-file editing. Workflow: Integrated chat with role-based responses and code suggestions.

### Claude Code Integration
Create separate Claude Code sessions for each role:
- /analyst - Market research and business analysis
- /pm - Project management and requirements  
- /po - Product owner validation and prioritization
- /ux - User experience design
- /architect - System design
- /sm - Scrum master for story management
- /dev - Development implementation
- /qa - Quality assurance and testing

### Web UI Integration
Get the bundle: Copy dist/teams/team-fullstack.txt (from repository). Create AI agent: Create a new Gemini Gem or CustomGPT. Upload & configure: Upload the file and set instructions: "Your critical operating instructions are attached, do not break character as directed"

## Advanced Features

### Document Sharding
Sharding Process: The shard-doc.md task breaks large planning documents into smaller, focused files for IDE development:
- docs/prd.md → docs/prd/ directory with epic-specific files
- docs/architecture.md → docs/architecture/ directory with component-specific files

### Codebase Flattening
BMad includes a powerful Codebase Flattener Tool—built to convert your full project codebase into a structured format optimized for AI model consumption.

```bash
npx bmad-method flatten --output my-code.xml
npx bmad-method flatten -o /custom/output/path/code.xml
```

### Expansion Packs
Expansion packs provide specialized AI agents for creative writing, business strategy, health & wellness, education, and more. BMad's natural language framework works in ANY domain.

Available expansion packs:
- Game Development (2D Unity)
- DevOps and Infrastructure  
- Creative Writing
- Business Strategy
- Health & Wellness
- Education

## Best Practices for Claude

### Context Management
As the context grows, the performance of the agent degrades, therefore it is important to instruct the agent to compact the conversation and start a new conversation with the compacted conversation as the initial message. Do this often, preferably after each story is implemented.

### Document-Driven Development
Each agent creates documents (PRD, Architecture, User Stories) that become the input for the next agent. It's like a factory assembly line where each station adds value and passes the product forward. The documents ARE your persistent context.

### Quality Assurance
- Always validate documents with the PO agent before moving to development
- Use the QA agent for comprehensive code reviews
- Maintain lean coding standards that get more specific as patterns emerge

### Workflow Sequence
Follow the standard workflow exactly:
1. Analyst → PM → Architect → PO → SM → Dev
2. Clear context between agents — But your documents carry forward automatically
3. Think of it like a relay race — Each agent hands off their work to the next

## Common Commands Summary

| Phase | Agent | Command | Purpose |
|-------|-------|---------|---------|
| Planning | Analyst | `*analyst` | Create project brief |
| Planning | PM | `*agent pm` | Create PRD from brief |
| Planning | UX Expert | `*agent ux` | Create UX specifications |
| Planning | Architect | `*agent architect` | Design system architecture |
| Planning | PO | `*agent po` | Validate and shard documents |
| Development | Scrum Master | `*agent sm` | Create development stories |
| Development | Developer | `*agent dev` | Implement code |
| Development | QA | `*agent qa` | Review and test |
| Any | Orchestrator | `#bmad-orchestrator` | General help and explanations |

## Troubleshooting

### Common Issues
1. **Context loss**: Compact conversations regularly and use document handoffs
2. **Missing dependencies**: Ensure all required documents are created before proceeding
3. **Configuration issues**: Check core-config.yaml and technical preferences
4. **Agent confusion**: Use specific agent commands and maintain role separation

### Getting Help
Join the Discord Community for help, ideas, collaboration on tech projects, and AI discussions. Whether you're stuck on BMad, building your own agents, or want to chat about AI - the community is there for support.

## Conclusion

The BMAD framework represents a significant leap forward in the software development lifecycle. At its core, it is a brilliantly simple yet powerful method for taming the often-chaotic process of "vibe coding" and replacing it with a structured, persona-driven workflow.

BMAD-METHOD transforms AI development from unstructured conversations into a systematic, agile-driven process with specialized agents handling specific roles. By following this guide, Claude can effectively orchestrate the entire development lifecycle from initial concept to final implementation, ensuring consistency, quality, and efficiency throughout the process.