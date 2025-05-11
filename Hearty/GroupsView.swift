//
//  GroupsView.swift
//  Hearty
//
//  Created by Jana Hamidaldeen on 2025-02-08.
//

import SwiftUI

struct GroupsView: View {
    @State private var groups: [Group] = [
        Group(name: "Family", members: [Person(name: "John", restrictions: ["Vegan"]), Person(name: "Jane", restrictions: ["Gluten-Free"])]),
        Group(name: "Friends", members: [Person(name: "Alice", restrictions: ["Nut Allergy"])])
    ]
    @State private var editingGroupId: UUID? = nil // Track the group being renamed or created
    @State private var addingNewGroup: Bool = false // Track if a new group is being added
    @State private var newGroupName: String = "" // Track the new group name

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(groups) { group in
                        HStack {
                            if editingGroupId == group.id {
                                TextField("Group Name", text: Binding(
                                    get: { group.name },
                                    set: { newValue in
                                        if let index = groups.firstIndex(where: { $0.id == group.id }) {
                                            groups[index].name = newValue
                                        }
                                    }
                                ), onCommit: {
                                    if let index = groups.firstIndex(where: { $0.id == group.id }), groups[index].name.isEmpty {
                                        groups.remove(at: index) // Remove group if no name is provided
                                    }
                                    editingGroupId = nil
                                    addingNewGroup = false // Stop editing on Enter key
                                })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity)
                            } else {
                                NavigationLink(destination: PeopleInGroupView(group: group)) {
                                    Text(group.name)
                                        .font(.headline)
                                }
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                if let index = groups.firstIndex(where: { $0.id == group.id }) {
                                    groups.remove(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                editingGroupId = group.id // Start editing the group name
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                        }
                    }

                    // Placeholder for adding a new group
                    if addingNewGroup {
                        HStack {
                            TextField("New Group", text: $newGroupName, onCommit: {
                                if newGroupName.isEmpty {
                                    addingNewGroup = false // Cancel adding if no name is entered
                                } else {
                                    let newGroup = Group(name: newGroupName, members: [])
                                    groups.append(newGroup)
                                    newGroupName = ""
                                    addingNewGroup = false
                                }
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

                Spacer()

                Button(action: {
                    addingNewGroup = true
                    newGroupName = ""
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add New Group")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Groups")
        }
    }
}
struct PeopleInGroupView: View {
    @State var group: Group
    @State private var showingAddPersonSheet = false
    @State private var showingEditPersonSheet = false
    @State private var selectedPerson: Person? = nil // Track the person being edited

    var body: some View {
        VStack {
            List {
                ForEach(group.members) { person in
                    HStack {
                        Text(person.name)
                            .font(.headline)
                        Spacer()
                        Text(person.restrictions.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            if let index = group.members.firstIndex(where: { $0.id == person.id }) {
                                group.members.remove(at: index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            selectedPerson = person
                            showingEditPersonSheet = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
            }

            Spacer()

            Button(action: {
                showingAddPersonSheet = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Person")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("\(group.name) Members")
        .sheet(isPresented: $showingAddPersonSheet) {
            AddPersonView(group: $group)
        }
        .sheet(isPresented: $showingEditPersonSheet) {
            if let person = selectedPerson {
                EditPersonView(group: $group, person: person)
            }
        }
    }
}


struct AddPersonView: View {
    @Binding var group: Group
    @State private var newPersonName: String = ""
    @State private var selectedRestrictions: [String] = []
    @Environment(\.presentationMode) var presentationMode

    let restrictionsOptions = ["Vegan", "Gluten-Free", "Nut Allergy", "Dairy-Free", "Vegetarian"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter name", text: $newPersonName)
                }

                Section(header: Text("Restrictions")) {
                    ForEach(restrictionsOptions, id: \.self) { restriction in
                        Toggle(restriction, isOn: Binding(
                            get: { selectedRestrictions.contains(restriction) },
                            set: { isSelected in
                                if isSelected {
                                    selectedRestrictions.append(restriction)
                                } else {
                                    selectedRestrictions.removeAll { $0 == restriction }
                                }
                            }
                        ))
                    }
                }
            }
            .navigationTitle("Add Person")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if !newPersonName.isEmpty {
                            let newPerson = Person(name: newPersonName, restrictions: selectedRestrictions)
                            group.members.append(newPerson)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct EditPersonView: View {
    @Binding var group: Group
    @State var person: Person // The person being edited
    @State private var updatedPersonName: String
    @State private var updatedRestrictions: [String]
    @Environment(\.presentationMode) var presentationMode

    let restrictionsOptions = ["Vegan", "Gluten-Free", "Nut Allergy", "Dairy-Free", "Vegetarian"]

    init(group: Binding<Group>, person: Person) {
        self._group = group
        self._person = State(initialValue: person)
        self._updatedPersonName = State(initialValue: person.name)
        self._updatedRestrictions = State(initialValue: person.restrictions)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter name", text: $updatedPersonName)
                }

                Section(header: Text("Restrictions")) {
                    ForEach(restrictionsOptions, id: \.self) { restriction in
                        Toggle(restriction, isOn: Binding(
                            get: { updatedRestrictions.contains(restriction) },
                            set: { isSelected in
                                if isSelected {
                                    updatedRestrictions.append(restriction)
                                } else {
                                    updatedRestrictions.removeAll { $0 == restriction }
                                }
                            }
                        ))
                    }
                }
            }
            .navigationTitle("Edit Person")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !updatedPersonName.isEmpty {
                            if let index = group.members.firstIndex(where: { $0.id == person.id }) {
                                group.members[index] = Person(name: updatedPersonName, restrictions: updatedRestrictions)
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}


struct Group: Identifiable {
    let id = UUID()
    var name: String
    var members: [Person]
}

struct Person: Identifiable {
    let id = UUID()
    var name: String
    var restrictions: [String]
}

#Preview {
    GroupsView()
}
